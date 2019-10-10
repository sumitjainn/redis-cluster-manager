# Redis Cluster Manager

Script to create and manage a redis cluster initialized with redis.conf

Allows to set and change the [cluster-announce-ip](http://download.redis.io/redis-stable/redis.conf) after the cluster is created

## Getting started

### How?

Clone this repo in Redis home directory 

`cd ~/dev/redis-5.0.5`

`git clone git@git.corp.adobe.com:sumjain/redis-cluster.git`

Or

Clone anywhere else and export path where redis binaries exist

`export REDISBIN_PATH=~/dev/redis-5.0.5/src`


### Configure Cluster Announce IP

export `REDISHOST=192.168.1.2` to set  `cluster-announce-ip` (Default is 127.0.0.1)

Also check Makefile to cutomize values of PORT, NUM_NODES, RELICAS

### Commands

- Create cluster and start `make create`
- Start cluster `make start`
- Stop cluster `make stop`
- Delete cluster `make delete`