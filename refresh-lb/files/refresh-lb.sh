#!/bin/bash
# 
# this script connect to puppet master and get the hostname of the load balancer
# it then connects to load balancer and force a refresh
# it is called when a new host has been added
#
# Olivier Renault -  0.1 - initial script
# 

# Get hostname for LB
LB_HOSTNAME=`curl -k -H "Accept: pson" https://puppet:8140/production/facts_search/search?facts.company_role=load-balancer | awk -F '\"' '{print $2}'`

# Connect to LB and force a refresh
curl -k -X PUT -H "Content-Type: text/pson" -d "{}" https://$LB_HOSTNAME:8139/production/run/no_key 

touch /tmp/register

exit 0 
