#!/bin/bash

REDISBIN="/Users/sumjain/Software/final/redis-cluster"
NODES_DIR=nodes

function usage(){
    echo "Usage: ./cluster.sh start|create|stop|delete -h=192.168.1.7 -p=30000 -n=3 -r=1"
    exit 1
}

if [[ $# -ne 5 ]]; then 
    usage
fi    


INDEX=0
for i in "$@"
do
if [ "$INDEX" == "0" ]; then 
    COMMAND="$i"
    #echo "$INDEX : $i"
else    
    case $i in
        -h=*|--host=*)
        HOST="${i#*=}"
        ;;
        -p=*|--port=*)
        PORT="${i#*=}"
        ;;
        -n=*|--num-nodes=*)
        COUNT="${i#*=}"
        ;;
        -r=*|--replicas=*)
        REPLICAS="${i#*=}"
        ;;
        --default)
        DEFAULT=YES
        ;;
        *)
        usage
        ;;
    esac
fi
let INDEX=${INDEX}+1
done

if [[ -z $HOST || -z $HOST || -z $HOST || -z $HOST ]]; then
      usage
fi


MINNODES=$(( (REPLICAS+1) * 3 )) 

if [[ ( "$COUNT" -lt 3 ) || ( "$COUNT" -lt "$MINNODES" ) ]]; then
    echo "Count should be minimum $MINNODES for REPLICAS: $REPLICAS  ..exiting"
    exit 1
fi

echo "command: $COMMAND"
echo "host: $HOST"
echo "start port: $PORT"
echo "count: $COUNT"
echo "replicas: $REPLICAS"

# Default case for Linux sed, just use "-i"
sedi=(-i)
case "$(uname)" in
  # For macOS, use two parameters
  Darwin*) sedi=(-i "")
esac

#exit 0
#set -x
echo "Executing $COMMAND"

if [ "$COMMAND" == "create" ]; then
    mkdir -p $NODES_DIR 
    cd $NODES_DIR; ls
    CURR=0
    CLUSTERSTR=""
    while [ $((CURR < COUNT)) != "0" ]; do
        DIR=$((PORT+CURR))
        mkdir $DIR
        cd $DIR ; pwd
        sed 's/${PORT}/'$DIR'/; s/${HOST}/'$HOST'/;' ../../redis.conf.tmpl > redis.conf
        ls
        CLUSTERSTR="$CLUSTERSTR $HOST:$DIR"
        #echo "$REDISBIN/redis-server redis.conf"
        $REDISBIN/redis-server redis.conf
        cd .. 
        CURR=$(( CURR + 1 )) 
    done
    ps -ef | grep redis
    CLUSTERCMD="$REDISBIN/redis-cli --cluster create $CLUSTERSTR --cluster-replicas $REPLICAS"
    echo $CLUSTERCMD
    $CLUSTERCMD
    sleep 5
    tail -f $NODES_DIR/**/*.log
    exit 0
fi    

if [ "$COMMAND" == "start" ]; then
    cd $NODES_DIR
    CURR=0
    while [ $((CURR < COUNT)) != "0" ]; do
        DIR=$((PORT+CURR))
        cd $DIR 
        #pwd
        rm redis.log
        #ls
        CURRHOST=$(awk -d" " '/cluster-announce-ip/ {print $2}' redis.conf)
        if [ "$CURRHOST" != "$HOST" ]; then
            echo "Host changed: CURR: $CURRHOST NEW: $HOST"
            sed "${sedi[@]}" -e "s/$CURRHOST/$HOST/g" *.conf
            #cat *.conf
        else 
            echo "Starting with curr host: $CURRHOST"     
        fi    

        CMDD="$REDISBIN/redis-server redis.conf"
        #echo "`pwd` $CMDD"
        $CMDD
        cd .. 
        CURR=$(( CURR + 1 )) 
        done
    cd ..    
    ps -ef | grep redis    
    tail -f $NODES_DIR/**/*.log
    exit 0
fi    

function stop(){
    ps -ef | grep redis   
    CURR=0
    while [ $((CURR < COUNT)) != "0" ]; do
        DIR=$((PORT+CURR))
        pkill ":$DIR \[cluster\]"
        CURR=$(( CURR + 1 )) 
    done 
    sleep 1   
    echo ""
    ps -ef | grep redis 
}

function stopAndDelete(){
    ps -ef | grep redis   
    CURR=0
    while [ $((CURR < COUNT)) != "0" ]; do
        DIR=$((PORT+CURR))
        echo "Stopping and deleting $DIR"
        pkill ":$DIR \[cluster\]"
        rm -rf $NODES_DIR/$DIR
        CURR=$(( CURR + 1 )) 
    done  
    sleep 1
    echo ""  
    ps -ef | grep redis 
}

if [ "$COMMAND" == "stop" ]; then
    stop   
    exit 0
fi  

if [ "$COMMAND" == "delete" ]; then
    stopAndDelete 
    exit 0
fi    


