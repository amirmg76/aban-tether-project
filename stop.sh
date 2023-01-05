#!/bin/bash

set -e

###############mongodb###################

docker-compose -f "mongo1/docker-compose.yml" down
docker-compose -f "mongo2/docker-compose.yml" down
docker-compose -f "mongo3/docker-compose.yml" down

rm -rf mongo1/.db
rm -rf mongo2/.db
rm -rf mongo3/.db



###########zookeeper##############

docker-compose -f "zookeeper1/docker-compose.yml" down
docker-compose -f "zookeeper2/docker-compose.yml" down
docker-compose -f "zookeeper3/docker-compose.yml" down

rm -rf zookeeper1/data
rm -rf zookeeper2/data
rm -rf zookeeper3/data


###########kafka###############

docker-compose -f "kafka1/docker-compose.yml" down
docker-compose -f "kafka2/docker-compose.yml" down
docker-compose -f "kafka3/docker-compose.yml" down

rm -rf kafka1/data
rm -rf kafka2/data
rm -rf kafka3/data

#############redis################


docker-compose -f "redis1/docker-compose.yml" down
docker-compose -f "redis2/docker-compose.yml" down
docker-compose -f "redis3/docker-compose.yml" down

rm -rf redis1/data
rm -rf redis2/data
rm -rf redis3/data

rm -rf redis1/sentinel_conf
rm -rf redis2/sentinel_conf
rm -rf redis3/sentinel_conf

##########python############

docker-compose -f "python-project1-1/docker-compose.yml" down
docker-compose -f "python-project2-1/docker-compose.yml" down
docker-compose -f "python-project1-2/docker-compose.yml" down
docker-compose -f "python-project2-2/docker-compose.yml" down
