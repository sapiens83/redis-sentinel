#!/bin/bash

ANNOUNCED_PORT=${ANNOUNCED_PORT}
MASTER_IP=${MASTER_IP}
#MASTER_PORT=${MASTER_PORT}
while true
do
MASTER_PORT=$(redis-cli -h 9.7.116.148 -p 6378 info server | grep tcp_port | cut -f2 -d :)
        if [ "MASTER_PORT" != "" ]; then
                break
        fi
        if [ "ANNOUNCED_PORT" == "31001" ]; then
                break
        fi
done

REDIS_CONFIGURATION_FILE=/etc/redis.conf

echo "bind 0.0.0.0" > $REDIS_CONFIGURATION_FILE
#echo "bind 127.0.0.1" > $REDIS_CONFIGURATION_FILE
#if [ -n "${MASTER_IP}" ] && [ -n "${MASTER_PORT}" ]; then

  echo "port ${ANNOUNCED_PORT}" >> $REDIS_CONFIGURATION_FILE
#else
 # echo "port 6379" >> $REDIS_CONFIGURATION_FILE
#fi
echo "dir ." >> $REDIS_CONFIGURATION_FILE

if [ -n "${MASTER_IP}" ] && [ -n "${MASTER_PORT}" ]; then
  echo "Redis running as a slave"
  echo "slaveof ${MASTER_IP} ${MASTER_PORT}" >> $REDIS_CONFIGURATION_FILE
fi

/usr/local/bin/redis-server $REDIS_CONFIGURATION_FILE
