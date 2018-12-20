#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#				
# Script Name:	log4bash.sh
#
# Author:		Sven Ramm
# Date:			12/19/2018
# Version:		2.0
#
# Fork of:		http://github.com/fredpalmer/log4bash
# 			Copyright (c) 2009-2011, Fred Palmer and contributors.
#				
# Purpose:		- Logging for bash scripts inclusive log rotation
#
# Notes:		- Usage:
#				log "info" "MESSAGE"
#				log "error" "MESSAGE"
#				log "warn" "MESSAGE"
#				log "success" "MESSAGE"
#				log "debug" "MESSAGE"
#
# Changes:		- 12/19/2018
#                  		- Script creation
#
# License:		Licensed under the MIT license
# 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Useful global variables that users may wish to reference
SCRIPT_ARGS="$@"
SCRIPTNAME="$0"
SCRIPTNAME="${SCRIPTNAME##*/}"
SCRIPTNAME="${SCRIPTNAME#\./}"
SCRIPT_BASE_DIR="$(cd "$( dirname "$0")" && pwd )"

declare -r LOG_DEFAULT_COLOR="\033[0m"
declare -r LOG_ERROR_COLOR="\033[1;31m"
declare -r LOG_INFO_COLOR="\033[1;37m"
declare -r LOG_SUCCESS_COLOR="\033[1;32m"
declare -r LOG_WARN_COLOR="\033[1;33m"
declare -r LOG_DEBUG_COLOR="\033[1;34m"

# Max filesize for LOG rotation
declare -r MaxLogSize=2048 # (2MB)
declare -r LOG_FILE="~/Library/Logs/log4bash.log"

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Function for Logging incl log rotation
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
log (){
	local log_level="$1"
	local log_text="$2"
	
	# Default to Info if second parameter is found missing assuming only message is provided
	[[ -z ${log_text} ]] && log_text="$1";

	shopt -s nocasematch
	case "${log_level}" in
	'info')
		log_level="INFO"
		log_color=${LOG_INFO_COLOR}
	;;
	'error')
		log_level="ERROR"
		log_color=${LOG_ERROR_COLOR}
	;;
	'warn')
		log_level="WARNING"
		log_color=${LOG_WARN_COLOR}
	;;
	'success')
		log_level="SUCCESS"
		log_color=${LOG_SUCCESS_COLOR}
	;;
	'debug')
		log_level="DEBUG"
		log_color=${LOG_DEBUG_COLOR}
	;;
	*)
		log_level="INFO"
		log_color=${LOG_DEFAULT_COLOR}
	;;
	esac

	echo -e "${log_color}[$(date +"%Y-%m-%d %H:%M:%S %Z")] [${log_level}] ${log_text} ${LOG_DEFAULT_COLOR}";
	
	# Log into File if given and considered Log rotation
	if [[ ! -z "${LOG_FILE}" ]]; then
		touch ${LOG_FILE}
		
		# Get size in kb** 
		file_size=`du -k "${LOG_FILE}" | cut -f1`
		if [ $file_size -gt ${MaxLogSize} ];then   
			timestamp=`date +"%Y-%m-%d_%H:%M:%S_%Z"`
			mv ${LOG_FILE} ${LOG_FILE}.${timestamp}
			touch ${LOG_FILE}
		fi
	
    	echo -e "[$(date +"%Y-%m-%d %H:%M:%S %Z")] [${SCRIPTNAME}] [${log_level}] ${log_text} " >> ${LOG_FILE}
    fi
    
    return 0;
}
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
