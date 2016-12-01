#!/bin/bash
# 
# Copyright (c) 2016, Search Solution Corporation. All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# 
#   * Redistributions of source code must retain the above copyright notice, 
#     this list of conditions and the following disclaimer.
# 
#   * Redistributions in binary form must reproduce the above copyright 
#     notice, this list of conditions and the following disclaimer in 
#     the documentation and/or other materials provided with the distribution.
# 
#   * Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products 
#     derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
#

jira_home_url="http://jira.cubrid.org/rest/api/2/issue/"

function usage
{
    cat <<CCTTPP
Usage: sh report_issue.sh <-u> jira user name <-p> jira user password [-i] issue number  <-d> issue data file
       Valid options :
        <-u>         : jira user name
        <-p>         : jira user password
	[-i]	     : issue number
        <-d>         : issue data file
CCTTPP
        exit 1
}

while getopts "u:p:d:i:h" opt; do
        case $opt in
                u)
                    user_name="$OPTARG"
                    ;;
                p)
                    user_password="$OPTARG"
                    ;;
		i)
		    issue_id="$OPTARG"
		    ;;
                d)
                    data_file="$OPTARG"
                    ;;
                \?)
                    usage
                    ;;
        esac
done


[ ! "$user_name" ] && echo "Please input jira user name" && exit 1
[ ! "$user_password" ] && echo "Please input jira user password" && exit 1


if [ "$data_file" ] && [ -f "$data_file" ];then
	if [ "$issue_id" ];then
		url="${jira_home_url}/${issue_id}/comment"
	else
		url="${jira_home_url}"
	fi
	
	curl -D- -u ${user_name}:${user_password} -X POST --data @${data_file} -H "Content-Type: application/json" $url
	if [ $? -ne ];then
		echo ""
		echo "[Info]: please confirm your user info (${user_name}:${user_password}) and data file($data_file)"
	else
		echo ""
		echo "[Info]: Success!"
	fi
else
	echo ""
	echo "Please input issue data file $data_file"
	exit 1
fi



