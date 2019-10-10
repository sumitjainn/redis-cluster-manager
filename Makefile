

NODES_DIR ?= "../src"
REDISHOST ?= "127.0.0.1"
PORT ?= 30001
NUM_NODES ?= 3
RELICAS ?= 0

create:
	./cluster.sh create -h=$(REDISHOST) -p=$(PORT) -n=$(NUM_NODES) -r=$(RELICAS)

start:
	./cluster.sh start -h=$(REDISHOST) -p=$(PORT) -n=$(NUM_NODES) -r=$(RELICAS)

stop:
	./cluster.sh stop -h=$(REDISHOST) -p=$(PORT) -n=$(NUM_NODES) -r=$(RELICAS)

delete:
	./cluster.sh delete -h=$(REDISHOST) -p=$(PORT) -n=$(NUM_NODES) -r=$(RELICAS)	

