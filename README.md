# ckp-dyn-ip-block
Check Point Script to block IP addresses pulled from a URL dynamically -  without policy push

#This is an automatic IP blocking script built for R80.40 using fwaccel dos functionality
#it uses dos  rate limit with a rate of 0 packets per source IP. Supports milions of entries and low overhead on the gateway
#No policy push is required

#References
#https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk112454&partition=Advanced&product=SecureXL,
#https://community.checkpoint.com/t5/General-Topics/R80-x-Performance-Tuning-Tip-DDoS-fw-sam-vs-fwaccel-dos/td-p/41525


#The script is designed to be deployed from one folder on the SMS/Management from where all files are copied.

#How to deploy script 
#Unzip to a folder you should have 
#blacklist-rf-block.sh
#blacklist-rf-log-clean.sh
#initial_setup_blacklist.sh
#CREATE a whitelist file and place it is $FWDIR/conf/dos-whitelist-v4.conf , a local feed file and a local gateway file; touch $FWDIR/conf/dos-whitelist-v4.conf; echo "10.0.0.0/8" > $FWDIR/conf/dos-whitelist-v4.conf
##Whitelist must contain multiple one line IPs or Subnets to be excepted. 
##The DoS whitelist is managed using the "fwaccel dos whitelist" command. Unlike the blacklist, the whitelist allows the use of CIDR expressions to whitelist entire networks. There is a single whitelist (i.e. there no "whitelist ID" parameter), and the whitelist applies to all 32 blacklists.
##feed file must contain exactly one line of URL to be blocked
##gateway file must contain SIC IP[SIC name] of destination gateways

#run the script once with -deploy then once with -on to make it start
#the script schedules itself to run every 15 minutes on each gateway
#you may also run -clean to remove the script from the gateways 

#log locations
	#on management 	tail -f $FWDIR/tmp/blacklist-rf-block.log
	#on gateways    tail -f $FWDIR/tmp/local_blacklist_rf_block.log

#HOW TO DEPLOY
#add whitelist example#
touch $FWDIR/conf/dos-whitelist-v4.conf; echo "10.0.0.0/8" > $FWDIR/conf/dos-whitelist-v4.conf
./initial_setup_blacklist.sh -a deploy -g gw.txt -f url.txt
#to check correct deployment go to security gateway and run: #cpd_sched_config print; fwaccel dos whitelist -s | wc-l; fwaccel dos blacklist -s | wc -l;  fwaccel dos stats get
./initial_setup_blacklist.sh -a on -g gw.txt -f url.txt
#HOW TO ENABLE
./initial_setup_blacklist.sh -a on -g gw.txt -f url.txt
#HOW TO DISABLE
./initial_setup_blacklist.sh -a off -g gw.txt -f url.txt
#HOW TO CLEAN
./initial_setup_blacklist.sh -a clean -g gw.txt -f url.txt
#manual disable: fwaccel dos config set --disable-internal; fwaccel dos config set --disable-blacklist; fwaccel dos  blacklist -F; fwaccel dos  whitelist -F

#HOW TO DEBUG

fwaccel dos stats get

#Usage: ./initial_setup_blacklist.sh -a <on|off|deploy|clean> [-g <gw_list_file>] [-f <feed_file>]
#Option:
#        -a on: activate blocking the IP addresses in the feeds
#        -a off: stops blocking the IP addresses in the feeds
#  		 -a deploy: copies the script over to the gateways
#	     -a clean: copies the script over to the gateways
#        -g gw_list_file: a list of GW IPs
#        -f feed_file: a single URL in a file
#Example:
#        ./initial_setup_blacklist.sh -a on -g local_gw_file -f local_url_file
# Make sure to have /home/admin/dos-whitelist-v4.conf /home/admin/blacklist-rf-log-clean.sh and /home/admin/blacklist-rf-block.sh

#cprid_util -server 10.128.36.25 -verbose rexec -rcmd bash -c "curl_cli --insecure https://esdcsv-secmg01.ptcnet.ptc.com/iprisklist.txt | wc -l"

#Commands needed to be run to enable
fwaccel dos  blacklist -l /home/admin/blacklist.txt
fwaccel dos  whitelist -l /home/admin/whitelist.txt


#Commands needed to disable
fwaccel dos config set --disable-internal
fwaccel dos config set --disable-blacklist
fwaccel dos  blacklist -F 
fwaccel dos  whitelist -F 

#check status
fwaccel dos  blacklist -s
fwaccel dos  whitelist -s

