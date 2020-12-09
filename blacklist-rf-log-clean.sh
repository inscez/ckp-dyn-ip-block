#!/bin/bash
if [ ! -f $FWDIR/tmp/blacklist-rf-block.log.bak ]
			then exit 0
			else 
					rm $FWDIR/tmp/blacklist-rf-block.log.bak
					mv $FWDIR/tmp/blacklist-rf-block.log $FWDIR/tmp/blacklist-rf-block.log.bak
			fi

if [ ! -f $FWDIR/tmp/blacklist-rf-block.log]
			then exit 0
			fi
			