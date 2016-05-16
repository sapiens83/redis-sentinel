#!/bin/bash

set -u
set -e

GROUP_NAME=${GROUP_NAME}
MASTER_IP=${MASTER_IP}
#MASTER_PORT=${MASTER_PORT}
while true
do
MASTER_PORT=$(redis-cli -h 9.7.116.148 -p 6378 info server | grep tcp_port | cut -f2 -d :)
        if [ "$MASTER_PORT" != "" ]; then
                #MASTER_IP=$(redis-cli -h 9.7.116.148 -p 6378 MONITOR & sleep 10 ; kill $!)
                #MASTER_IP=$(echo -e  "$MASTER_IP"|cut -f2 -d[ | cut -f2 -d " "| cut -f1 -d: | tail -n 1 )
                #echo $MASTER_IP
                echo $MASTER_PORT
                break
        fi
done
QUORUM=${QUORUM}
#ANNOUNCED_IP=${ANNOUNCED_IP}
ANNOUNCED_PORT=${ANNOUNCED_PORT}
SENTINEL_CONFIGURATION_FILE=/etc/sentinel.conf

# Host and port we will listen for requests on
echo "bind 0.0.0.0" > $SENTINEL_CONFIGURATION_FILE
#echo "port 6379" >> $SENTINEL_CONFIGURATION_FILE
echo "port $ANNOUNCED_PORT" >> $SENTINEL_CONFIGURATION_FILE
echo "sentinel monitor $GROUP_NAME $MASTER_IP $MASTER_PORT $QUORUM" >> $SENTINEL_CONFIGURATION_FILE
echo "sentinel down-after-milliseconds $GROUP_NAME 5000" >> $SENTINEL_CONFIGURATION_FILE
echo "sentinel failover-timeout $GROUP_NAME 5000" >> $SENTINEL_CONFIGURATION_FILE
echo "sentinel parallel-syncs $GROUP_NAME 1" >> $SENTINEL_CONFIGURATION_FILE
#echo "sentinel announce-ip ${ANNOUNCED_IP}" >> $SENTINEL_CONFIGURATION_FILE
#echo "sentinel announce-port ${ANNOUNCED_PORT}" >> $SENTINEL_CONFIGURATION_FILE
#echo "sentinel known-slave redis ${ANNOUNCED_IP} ${ANNOUNCED_PORT}" >> $SENTINEL_CONFIGURATION_FILE

/usr/local/bin/redis-server $SENTINEL_CONFIGURATION_FILE --sentinel
