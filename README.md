# Redis Cluster Manager

Script to create and manage a redis cluster initialized with redis.conf

Allows to set and change the `cluster-announce-ip` after the cluster is created

## Getting started

### How?

export `REDISHOST=192.168.1.2` to set  `cluster-announce-ip` (Default is 127.0.0.1)

Also check Makefile to cutomize values of PORT, NUM_NODES, RELICAS

### Commands

- Create cluster and start `make create`
- Start cluster `make start`
- Stop cluster `make stop`
- Delete cluster `make delete`