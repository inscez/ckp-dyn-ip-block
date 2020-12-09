#!/bin/bash


SCRIPT_NAME=$0
LOCAL_LOG="$FWDIR/tmp/local_blacklist_rf_block.log"
echo "Loogging to $LOCAL_LOG "

function log_line {
	# add timestamp to all log lines
	message=$1
	local_log_file=$2
	echo "$(date) $message" >> $local_log_file
}

action=""

if [ "$2" == "redeploy" ]; 
	then 
	test_file_exists=$(test -f $FWDIR/conf/blacklists/blacklist-rf.txt)
	if [ ! $? -eq 0 ]; 
		then 
		log_line "Blacklist File does NOT exist; Creating it" $LOCAL_LOG ;
		test_folder=$(test -d $FWDIR/conf/blacklists/blacklists/)
			if [ ! $? -eq 0 ]; 
			then mkdir $FWDIR/conf/blacklists/blacklists/ 
			log_line "Directory does NOT exist; Creating it" $LOCAL_LOG ;
			fi
	
	touch $FWDIR/conf/blacklists/blacklist-rf.txt
	fi
fi

echo "This is only designed for R80.40"
fw ver | grep 'R80.40' -q
if [ $? == 0 ]; 
then
  
  echo "Running script"
  log_line "Running script locally with paramters $0 " $LOCAL_LOG
  test_file_exists=$(test -f $FWDIR/conf/blacklists/blacklist-rf.txt)

function update_url {
#Check that the file has only one URL 
if [ `cat local_feed_file.txt | wc -l` -ge "2" ];
then  echo "This has more than 1 line." ; log_line "ERR: URL file has more than one URL " $LOG_FILE; exit 1;
else  log_line "Parsed URL file and it has only one line " $LOG_FILE;
fi
			test_file_exists=$(test -f $FWDIR/conf/feed_file_url.txt)
			if [ ! $? -eq 0 ]; then log_line "ERR: URL FILE DOES NOT EXIST " $LOG_FILE; exit 1;
			else
				while IFS= read -r line
				do
				write_url="$line"
				done < "$FWDIR/conf/feed_file_url.txt"
				echo "Accessing URL " $write_url
				log_line "Accessing URL $write_url " $LOG_FILE;
			fi


#Populate initial Blacklist files			
				test_file_exists=$(test -f $FWDIR/conf/blacklists/blacklist-rf.txt)
					if [ ! $? -eq 0 ]; then echo "file does NOT exist; Stopping" ; exit 1
					else
					get_ip=$(curl_cli -s --insecure --retry 10 --retry-delay 60 $write_url | dos2unix | grep -vE '^$' >  $FWDIR/tmp/cachefile)
						if [ ! $? -eq 0 ]; then echo "failed to update blacklist; Stopping;" ; log_line "Failed to update blacklist file from URL on $localhostname " $LOG_FILE; exit 1
							else
							if ! cmp -s $FWDIR/conf/blacklists/blacklist-rf.txt $FWDIR/tmp/cachefile; 
							then mv $FWDIR/tmp/cachefile $FWDIR/conf/blacklists/blacklist-rf.txt 
								numip=$(cat $FWDIR/conf/blacklists/blacklist-rf.txt | wc -l)	
								echo "Changes detected; Updating blacklist with new IP"; log_line "Populated initial blacklist file on $localhostname with $numip addresses" $LOG_FILE;
								else echo "No changes detected; Leaving old blacklist contents"; log_line "Keeping old blacklist file on $localhostname " $LOG_FILE;
							fi
						fi
					fi
			
			}

function enable_blocking {
update_url
log_line "Running ENABLE MODE " $LOCAL_LOG

fwaccel dos  whitelist -l $FWDIR/conf/dos-whitelist-v4.conf
log_line "Enabled local whitelist $FWDIR/conf/dos-whitelist-v4.conf " $LOCAL_LOG

fwaccel dos config set --enable-internal
fwaccel dos config set --enable-blacklist
fwaccel dos config set --enable-log-drops
log_line "Enabled params --enable-internal --enable-blacklist --enable-log-drops" $LOCAL_LOG

fwaccel dos  blacklist -l $FWDIR/conf/blacklists/blacklist-rf.txt
log_line "Enabled local blacklist $FWDIR/conf/blacklists/blacklist-rf.txt" $LOCAL_LOG
}

function disable_blocking {
log_line "Running DISABLE MODE " $LOCAL_LOG
fwaccel dos config set --disable-internal
fwaccel dos config set --disable-blacklist
fwaccel dos  blacklist -F 
fwaccel dos  whitelist -F 
log_line "Flushed all blacklists" $LOCAL_LOG
}

function clean_blocking {

log_line "Running CLEANUP MODE " $LOCAL_LOG
fwaccel dos config set --disable-internal
fwaccel dos config set --disable-blacklist
fwaccel dos  blacklist -F 
fwaccel dos  whitelist -F 
log_line "Flushed all blacklists" $LOCAL_LOG

rm $FWDIR/conf/blacklists/blacklist-rf.txt
if [ $? -eq 0 ]; then log_line "Removing blacklist file $FWDIR/conf/blacklists/blacklist-rf.txt" $LOCAL_LOG; else log_line "ERR: Failed to remove blacklist file $FWDIR/conf/blacklists/blacklist-rf.txt" $LOCAL_LOG; fi
rm $FWDIR/conf/dos-whitelist-v4.conf.txt
if [ $? -eq 0 ]; then log_line "Removing whitelist file $FWDIR/conf/dos-whitelist-v4.conf.txt" $LOCAL_LOG; else log_line "ERR: Failed to remove whitelist file $FWDIR/conf/dos-whitelist-v4.conf.txt" $LOCAL_LOG; fi
rm $FWDIR/conf/fwaccel_dos_rate_on_install
if [ $? -eq 0 ]; then log_line "Removing confg file $FWDIR/conf/fwaccel_dos_rate_on_install" $LOCAL_LOG; else log_line "ERR: Failed to remove confg file $FWDIR/conf/fwaccel_dos_rate_on_install" $LOCAL_LOG; fi
rm -r $FWDIR/conf/blacklists/blacklists/
if [ $? -eq 0 ]; then log_line "Removing blacklist directory $FWDIR/conf/blacklists/blacklists/" $LOCAL_LOG; else log_line "ERR: Failed to remove blacklist directory $FWDIR/conf/blacklists/blacklists/" $LOCAL_LOG; fi
rm $FWDIR/conf/feed_file_url.txt
if [ $? -eq 0 ]; then log_line "Removing URL feed file $FWDIR/conf/feed_file_url.txt" $LOCAL_LOG; else log_line "ERR: Failed to remove URL feed file  FWDIR/conf/feed_file_url.txt" $LOCAL_LOG; fi
}

function redeploy_blocking {
		update_url
		log_line "Running REDEPLOY LOCAL MODE" $LOCAL_LOG;
		get_ip=$(curl_cli -s --insecure --retry 10 --retry-delay 60 $write_url | dos2unix | grep -vE '^$' >  $FWDIR/tmp/cachefile)
			if [ ! $? -eq 0 ]; then log_line "failed to update blacklist; Stopping;" $LOCAL_LOG ; exit 1
			else
				if ! cmp -s $FWDIR/conf/blacklists/blacklist-rf.txt $FWDIR/tmp/cachefile; 
				then mv $FWDIR/tmp/cachefile $FWDIR/conf/blacklists/blacklist-rf.txt 
				log_line "Changes detected; Updating blacklist with new IP" $LOCAL_LOG
				else log_line "No changes detected; Leaving old blacklist contents" $LOCAL_LOG
				fi
			fi
	
}

#help info
usage() { 
	echo "Usage: $0 -a <on|off|clean|redeploy> -f <feed_file>" 1>&2; 
	echo "Option:" 1>&2; 
	echo "	-a on: activate blocking the IP addresses in the feeds" 1>&2; 
	echo "	-a off: stops blocking the IP addresses in the feeds" 1>&2; 
	echo "  -a clean: clears all local files" 1>&2;
	echo "  -a redeploy: clears all local files" 1>&2;
	echo "  -f url_feed_file: file with only 1 URL to block" 1>&2;
	echo "Example:" 1>&2; 
	echo "	$0 -a on"
	echo "	$0 -a off"
	echo "	$0 -a clean"
	echo "  $0 -a redeploy"
	log_line "Script ended on usage" $LOG_FILE
	exit 1; 
}

while getopts ":a:f:" o; do
	case "${o}" in
        a)
			op=${OPTARG}
            ((op == "on" || op == "off" || op == "clean" || op == "redeploy" )) || usage
            ;;
		f)
			url_feed=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))


if  [ -z "$url_feed" ]
then
	echo "Error: missing URL file" 1>&2;
	log_line "Missing URL file" $LOG_FILE
	usage
fi

if  [ -z "$op" ] 
then
	usage
fi

case "$op" in
	on)
	action="-a on"
	enable_blocking
	;;
	off)
	action="-a off"
	disable_blocking
	;;
	clean)
	action="-a clean"
	clean_blocking
	;;
	redeploy)
	action="-a redeploy"
	redeploy_blocking
	;;
	*)
	usage
esac

fi

