#!/bin/bash


echo "This is only designed for R80.40"
fw ver | grep 'R80.40' -q
if [ $? == 0 ]; then
  echo "Running script"

#remote_fwdir=$(cprid_util -server 10.128.36.25 -stdout /home/admin/blocklist.log getenv -attr "FWDIR"); 
#remote_feed_file="$remote_fwdir/conf/dos-whitelist-v4.conf"; 
#move_feed=$(cprid_util -server 10.128.36.25 putfile -local_file $FWDIR/conf/dos-whitelist-v4.conf -remote_file $remote_feed_file); 
#echo $remote_fwdir

#cprid_util -server 10.128.36.25 putfile -local_file $FWDIR/conf/dos-whitelist-v4.conf -remote_file $FWDIR/conf/dos-whitelist-v4.conf 

LOCAL_TMP_LOG_FILE="$FWDIR/tmp/tmp_local_blacklist_rf_block.tmp"
SCRIPT_NAME=$0

action=""
param=""

LOG_FILE="$FWDIR/tmp/blacklist-rf-block.log"
echo "Logging to $LOG_FILE"
function log_line {
	# add timestamp to all log lines
	message=$1
	local_log_file=$2
	echo "$(date) $message" >> $local_log_file
}




localhostname=$(hostname -f)
log_line "Script started running on gateways from $localhostname" $LOG_FILE

#First time setup

#Create local files

			if [ ! -d $FWDIR/conf/blacklists/ ]
			then
				echo "Local Directory $FWDIR/conf/blacklists/blacklists/ does not exist -> creating"
				mkdir $FWDIR/conf/blacklists/
			else echo "Local Directory $FWDIR/conf/blacklists/ exists -> nothing to do"
			fi
			if [ ! -f $FWDIR/conf/blacklists/blacklist-rf.txt ]
			then
				echo "Local $FWDIR/conf/blacklists/blacklist-rf.txt does not exist -> creating"
				#Creating local Blacklist files
				touch $FWDIR/conf/blacklists/blacklist-rf.txt
			else echo "Local $FWDIR/conf/blacklists/blacklist-rf.txt exists -> nothing to do"
			fi
			
function update_url {
#Check that the file has only one URL 
if [ `cat local_feed_file.txt | wc -l` -ge "2" ];
then  echo "This has more than 1 line." ; log_line "ERR: URL file has more than one URL " $LOG_FILE; exit 1;
else  log_line "Parsed URL file and it has only one line " $LOG_FILE;

while IFS= read -r line
do
  write_url="$line"
done < "$url_feed"
echo "Accessing URL " $write_url
log_line "Accessing URL $write_url " $LOG_FILE;
echo $write_url > $FWDIR/conf/feed_file_url.txt;

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
			
			
			if [ ! -f $FWDIR/conf/dos-whitelist-v4.conf ]
			then
				echo "Local $FWDIR/conf/dos-whitelist-v4.conf does not exist -> creating"
				touch $FWDIR/conf/dos-whitelist-v4.conf
			else echo "Local $FWDIR/conf/dos-whitelist-v4.conf exists -> nothing to do"
			fi
			if [ ! -f $FWDIR/conf/fwaccel_dos_rate_on_install ]
			then
				echo "Local $FWDIR/conf/fwaccel_dos_rate_on_install does not exist -> creating"
				touch $FWDIR/conf/fwaccel_dos_rate_on_install
				echo '#!/bin/bash' > $FWDIR/conf/fwaccel_dos_rate_on_install
				echo -e "fwaccel dos config set --enable-internal\nfwaccel dos config set --enable-blacklist\nfwaccel dos config set --enable-log-drops\nfwaccel dos config set --notif-rate 5" >> $FWDIR/conf/fwaccel_dos_rate_on_install
			else echo "Local $FWDIR/conf/fwaccel_dos_rate_on_install exists -> nothing to do"
			fi

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  TARGET="$(readlink "$SOURCE")"
  if [[ $TARGET == /* ]]; then
    echo "SOURCE '$SOURCE' is an absolute symlink to '$TARGET'"
    SOURCE="$TARGET"
  else
    DIR="$( dirname "$SOURCE" )"
    echo "SOURCE '$SOURCE' is a relative symlink to '$TARGET' (relative to '$DIR')"
    SOURCE="$DIR/$TARGET" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  fi
done
echo "SOURCE is '$SOURCE'"
RDIR="$( dirname "$SOURCE" )"
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
if [ "$DIR" != "$RDIR" ]; then
  echo "DIR '$RDIR' resolves to '$DIR'"
fi
echo "DIR is '$DIR'"


			if [ ! -f $DIR/blacklist-rf-block.sh ]
				then echo "Local $DIR/blacklist-rf-block.sh is missing, please add it" ; log_line "Missing $DIR/blacklist-rf-block.sh, stopping " $LOG_FILE; 	exit 1;
			else	echo "$DIR/blacklist-rf-block.sh exists!"

			if [ ! -f $FWDIR/conf/blacklist-rf-block.sh ]
			then
				echo "Local $FWDIR/conf/blacklist-rf-block.sh does not exist -> creating"
				touch $FWDIR/conf/blacklist-rf-block.sh
				cp $DIR/blacklist-rf-block.sh $FWDIR/conf/blacklist-rf-block.sh
				echo "Copied local script to $FWDIR/conf/blacklist-rf-block.sh"
			else echo "Local $FWDIR/conf/blacklist-rf-block.sh exists -> nothing to do"
			cp $DIR/blacklist-rf-block.sh $FWDIR/conf/blacklist-rf-block.sh
			echo "Copied local script to $FWDIR/conf/blacklist-rf-block.sh"
			fi
			fi
			
			if [ ! -f $DIR/dos-whitelist-v4.conf ]
				then echo "Local $DIR/dos-whitelist-v4.conf is missing, please add it" ;log_line "Missing $DIR/dos-whitelist-v4.conf, stopping " $LOG_FILE;exit 1;
			else	echo "$DIR/dos-whitelist-v4.conf exists!"

			if [ ! -f $FWDIR/conf/dos-whitelist-v4.conf ]
			then
				echo "Local $FWDIR/conf/dos-whitelist-v4.conf does not exist -> creating"
				touch $FWDIR/conf/dos-whitelist-v4.conf
				cp $DIR/dos-whitelist-v4.conf $FWDIR/conf/dos-whitelist-v4.conf
				echo "Copied local script to $FWDIR/conf/dos-whitelist-v4.conf"
			else echo "Local $FWDIR/conf/dos-whitelist-v4.conf exists -> nothing to do"
			cp $DIR/dos-whitelist-v4.conf $FWDIR/conf/dos-whitelist-v4.conf
			echo "Copied local script to $FWDIR/conf/dos-whitelist-v4.conf"
			fi
			fi
			
			if [ ! -f $DIR/blacklist-rf-log-clean.sh ]
				then echo "Local $DIR/blacklist-rf-log-clean.sh is missing, please add it" ;log_line "Missing $DIR/blacklist-rf-log-clean.sh, stopping " $LOG_FILE;exit 1;
			else	echo "$DIR/blacklist-rf-log-clean.sh exists!"

			if [ ! -f $FWDIR/conf/blacklist-rf-log-clean.sh ]
			then
				echo "Local $FWDIR/conf/blacklist-rf-log-clean.sh does not exist -> creating"
				touch $FWDIR/conf/blacklist-rf-log-clean.sh
				cp $DIR/blacklist-rf-log-clean.sh $FWDIR/conf/blacklist-rf-log-clean.sh
				echo "Copied local script to $FWDIR/conf/blacklist-rf-log-clean.sh"
			else echo "Local $FWDIR/conf/blacklist-rf-log-clean.sh exists -> nothing to do"
			cp $DIR/blacklist-rf-log-clean.sh $FWDIR/conf/blacklist-rf-log-clean.sh
			echo "Copied local script to $FWDIR/conf/blacklist-rf-log-clean.sh"
			fi
			fi
			
			

REMOTE_TMP_LOG_FILE="$FWDIR/tmp/remote_blacklist-rf-block.log"

function run_gw_list {
	 log_line "Running update from URL $url_feed" $LOG_FILE
	 update_url
     while read gw_ip; do
        if [ ! -z "$gw_ip" ] && [ ${gw_ip:0:1} != "#" ]
        then
#Get remote FW DIR
					remote_fwdir=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE getenv -attr "FWDIR")
					if  [ -z "$remote_fwdir" ]
					then
						echo "Error: could not retrieve FWDIR from $gw_ip" 1>&2; 
						log_line "Error: could not retrieve FWDIR from $gw_ip" $LOG_FILE
						exit 1
					else log_line "Successfully RETRIEVED FWDIR from $gw_ip" $LOG_FILE
					fi

#deploy script
remote_blacklist_file="$remote_fwdir/conf/blacklists/blacklist-rf.txt"
remote_whitelist_file="$remote_fwdir/conf/dos-whitelist-v4.conf"
remote_conf_file="$remote_fwdir/conf/fwaccel_dos_rate_on_install"
remote_feed_file="$remote_fwdir/conf/feed_file_url.txt"
remote_script_file="$remote_fwdir/conf/blacklist-rf-block.sh"
remote_clean_log_file="$remote_fwdir/conf/blacklist-rf-log-clean.sh"
			if [ "$action" = "deploy" ]
				then
				log_line "deploying to $gw_ip" $LOG_FILE
				
				


#result=$(cprid_util -server $gw_ip getfile -local_file $LOCAL_TMP_LOG_FILE -remote_file $REMOTE_TMP_LOG_FILE)
#does_file_exist=$(cat $LOCAL_TMP_LOG_FILE)
#if [ -z $does_file_exist ]
#			then
#				echo "Error: $remote_script_file does not exist on $gw_ip"
#				return
#			fi
#echo "$gw_ip response:"
#cat $LOCAL_TMP_LOG_FILE 
#cat $LOCAL_TMP_LOG_FILE >> $LOG_FILE


			#Get remote file path
			
			#Create directories and files on remote gateways
			check_dir_blacklist=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE -verbose rexec -rcmd bash -c "test -d $remote_fwdir/conf/blacklists/")
			if [ $? -eq 0 ]; then  log_line "DIR $remote_fwdir/conf/blacklists/ Already exists " $LOG_FILE ; 
					else log_line "DIR $remote_fwdir/conf/blacklists/ needs to be created" $LOG_FILE ; 
						  make_dir_blacklist=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE -verbose rexec -rcmd bash -c "mkdir $remote_fwdir/conf/blacklists/")
						  if [ $? -eq 0 ]; then  log_line "Created DIR $remote_fwdir/conf/blacklists/ " $LOG_FILE ; else log_line "ERR:FAILED to create $remote_fwdir/conf/blacklists/" $LOG_FILE ;  fi
			fi
			move_feed_conf=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE putfile -local_file $FWDIR/conf/fwaccel_dos_rate_on_install -remote_file $remote_conf_file)
			if [ $? -eq 0 ]; then  log_line "Successfully Copied $remote_conf_file " $LOG_FILE ; else log_line "ERR:FAILED to copy $remote_conf_file" $LOG_FILE ;  fi
			run_feed_conf=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE -verbose rexec -rcmd bash -c "chmod +x $remote_conf_file")
			if [ $? -eq 0 ]; then  log_line "Successfully Made $remote_conf_file executable " $LOG_FILE ; else log_line "ERR:FAILED to make executable $remote_conf_file" $LOG_FILE ;  fi
			move_feed_whitelist=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE putfile -local_file $FWDIR/conf/dos-whitelist-v4.conf -remote_file $remote_whitelist_file)
			if [ $? -eq 0 ]; then  log_line "Successfully Copied $remote_whitelist_file " $LOG_FILE ; else log_line "ERR:FAILED to copy $remote_whitelist_file" $LOG_FILE ;  fi
			move_feed_blacklist=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE putfile -local_file $FWDIR/conf/blacklists/blacklist-rf.txt -remote_file $remote_blacklist_file)
			if [ $? -eq 0 ]; then  log_line "Successfully Copied $remote_blacklist_file " $LOG_FILE ; else log_line "ERR:FAILED to copy $remote_blacklist_file" $LOG_FILE ;  fi
			move_feed_file=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE putfile -local_file $FWDIR/conf/feed_file_url.txt -remote_file $remote_feed_file)
			if [ $? -eq 0 ]; then  log_line "Successfully Copied $remote_feed_file " $LOG_FILE ; else log_line "ERR:FAILED to copy $remote_feed_file" $LOG_FILE ;  fi
			move_clean_script=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE putfile -local_file $FWDIR/conf/blacklist-rf-log-clean.sh -remote_file $remote_clean_log_file)
			if [ $? -eq 0 ]; then  log_line "Successfully Copied $remote_clean_log_file " $LOG_FILE ; else log_line "ERR:FAILED to copy $remote_clean_log_file" $LOG_FILE ;  fi
			runme=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE -verbose rexec -rcmd bash -c "chmod +x $remote_clean_log_file")
			if [ $? -eq 0 ]; then  log_line "Successfully Made $remote_clean_log_file executable " $LOG_FILE ; else log_line "ERR:FAILED to make executable $remote_clean_log_file" $LOG_FILE ;  fi
			#Check if file already exists	
			#log_line "verify $remote_script_file exists on $gw_ip" $LOG_FILE			
			#runme=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE -verbose rexec -rcmd bash -c "test -f $remote_script_file")
				#if [ $? -eq 0 ]; then  log_line "File already exists on $gw_ip " $LOG_FILE ; 
				#else log_line "File does NOT EXIST on $gw_ip and will be created" $LOG_FILE ;  				
					move_feed_script_file=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE putfile -local_file $FWDIR/conf/blacklist-rf-block.sh -remote_file $remote_script_file)
					if [ $? -eq 0 ]; then  log_line "Successfully Copied $remote_script_file" $LOG_FILE ; else log_line "ERR:FAILED to copy $remote_script_file" $LOG_FILE ;  fi
					run_feed_script_file=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE -verbose rexec -rcmd bash -c "chmod +x $remote_script_file")
					if [ $? -eq 0 ]; then  log_line "Successfully Made $remote_script_file executable " $LOG_FILE ; else log_line "ERR:FAILED to make executable $remote_script_file" $LOG_FILE ;  fi
				#fi
			runme=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE -verbose rexec -rcmd bash -c "cpd_sched_config add \"RFBlockScriptClean\" -c \"$remote_fwdir/conf/blacklist-rf-log-clean.sh\" -e 2000000")
			if [ $? -eq 0 ]; then  log_line "Added script to the Task Scheduler " $LOG_FILE ; else log_line "ERR:FAILED to add the script to the Task Scheduler" $LOG_FILE ;  fi
			
			log_line "Attempt to move files done" $LOG_FILE
			fi
			if [ "$action" == "on" ]; then 
			runme=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE -verbose rexec -rcmd bash -c "$remote_script_file -a on -f $remote_feed_file")
			log_line "Started blocking script on $gw_ip  " $LOG_FILE
			runme=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE -verbose rexec -rcmd bash -c "cpd_sched_config add \"RFBlock\" -c \"$remote_fwdir/conf/blacklist-rf-block.sh \" -v \"-a on -f local_feed_file.txt\" -e 1200 -r -s")
			if [ $? -eq 0 ]; then  log_line "Added script to the Task Scheduler " $LOG_FILE ; else log_line "ERR:FAILED to add the script to the Task Scheduler" $LOG_FILE ;  fi
			fi
			if [ "$action" == "off" ]; then 
			runme=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE -verbose rexec -rcmd bash -c "$remote_script_file -a off -f $remote_feed_file")
			log_line "Stopped blocking script on $gw_ip  " $LOG_FILE
			runme=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE -verbose rexec -rcmd bash -c "cpd_sched_config delete \"RFBlock\"")
			if [ $? -eq 0 ]; then  log_line "Removed script from Task Scheduler " $LOG_FILE ; else log_line "ERR:FAILED to remove script from Task Scheduler" $LOG_FILE ;  fi
			fi
			if [ "$action" == "clean" ]; then 
			runme=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE -verbose rexec -rcmd bash -c "$remote_script_file -a clean -f $remote_feed_file")
			log_line "Cleared blocking script files on $gw_ip " $LOG_FILE
			runme=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE -verbose rexec -rcmd bash -c "cpd_sched_config delete \"RFBlock\"")
			if [ $? -eq 0 ]; then  log_line "Removed script from Task Scheduler " $LOG_FILE ; else log_line "ERR:FAILED to remove script from Task Scheduler" $LOG_FILE ;  fi
			runme=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE -verbose rexec -rcmd bash -c "cpd_sched_config delete \"RFBlockScriptClean\"")
			if [ $? -eq 0 ]; then  log_line "Removed script that cleans RF logs from Task Scheduler " $LOG_FILE ; else log_line "ERR:FAILED to remove script that cleans RF logs from Task Scheduler" $LOG_FILE ;  fi
			delete_remote_script_file=$(cprid_util -server $gw_ip -stdout $REMOTE_TMP_LOG_FILE -verbose rexec -rcmd bash -c "rm $remote_fwdir/conf/blacklist-rf-block.sh")
			if [ $? -eq 0 ]; then  log_line "Successfully Removed $remote_script_file_file " $LOG_FILE ; else log_line "ERR:FAILED to remove $remote_script_file" $LOG_FILE ;  fi
			fi
        fi
     done 
}

fi

#help info
usage() { 
	echo "Usage: $0 -a <on|off|deploy|clean> [-g <gw_list_file>] [-f <feed_file>]" 1>&2; 
	echo "Option:" 1>&2; 
	echo "	-a on: activate blocking the IP addresses in the feeds" 1>&2; 
	echo "	-a off: stops blocking the IP addresses in the feeds" 1>&2; 
	echo "  -a deploy: copies the script over to the gateways" 1>&2;
	echo "  -a clean: copies the script over to the gateways" 1>&2;
	echo "	-g gw_list_file: a list of GW IPs" 1>&2; 
	echo "	-f feed_file: a single URL in a file" 1>&2; 
	#echo "	-w whitelist file: a list of IPs to bypass" 1>&2; 
	#echo "	-f feed_file: a list of feeds URLs with IPs to block" 1>&2; 
	#echo "	-s script_file: full path to ip_block.sh to copy to the GWs" 1>&2; 
	echo "Example:" 1>&2; 
	echo "	$0 -a on -g local_gw_file -f local_url_file"
	echo " Make sure to have $DIR/dos-whitelist-v4.conf $DIR/blacklist-rf-log-clean.sh and $DIR/blacklist-rf-block.sh  "
	log_line "Script ended on usage" $LOG_FILE
	exit 1; 
}

while getopts ":a:g:f:" o; do
	case "${o}" in
        a)
			op=${OPTARG}
            ((op == "on" || op == "off" || op == "deploy" || op == "clean" )) || usage
            ;;
        g)
            gw_list_file=${OPTARG}
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


if  [ -z "$op" ] 
then
	usage
fi

if  [ -z "$gw_list_file" ]
then
	echo "Error: missing gw list file" 1>&2;
	log_line "Missing gw list file" $LOG_FILE
	usage
fi


if  [ -z "$url_feed" ]
then
	echo "Error: missing URL file" 1>&2;
	log_line "Missing URL file" $LOG_FILE
	usage
fi

case "$op" in
	on)
	action="on"
	cat $gw_list_file | grep -vE '^$'| run_gw_list
	;;
	off)
	action="off"
	cat $gw_list_file | grep -vE '^$'| run_gw_list
	;;
	deploy)
	action="deploy"
	cat $gw_list_file | grep -vE '^$'| run_gw_list
	;;
	clean)
	action="clean"
	cat $gw_list_file | grep -vE '^$'| run_gw_list
	;;
	*)
	usage
esac



log_line "Clearing local blacklist file $FWDIR/conf/blacklists/blacklist-rf.txt" $LOG_FILE
echo "" > $FWDIR/conf/blacklists/blacklist-rf.txt
log_line "Script ended on $localhostname " $LOG_FILE

