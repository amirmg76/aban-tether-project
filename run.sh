#!/bin/bash

set -e

###############mongodb###################

docker-compose -f "mongo1/docker-compose.yml" down
docker-compose -f "mongo2/docker-compose.yml" down
docker-compose -f "mongo3/docker-compose.yml" down

rm -rf mongo1/.db
rm -rf mongo2/.db
rm -rf mongo3/.db

cp mongodb.conf mongo1/config/mongodb.conf
cp mongodb.conf mongo2/config/mongodb.conf
cp mongodb.conf mongo3/config/mongodb.conf

sed -i  's/27017/27018/g' mongo2/config/mongodb.conf
sed -i  's/27017/27019/g' mongo3/config/mongodb.conf


docker-compose -f "mongo1/docker-compose.yml" up -d
docker-compose -f "mongo2/docker-compose.yml" up -d
docker-compose -f "mongo3/docker-compose.yml" up -d

M1_OPTS="--tls --tlsCAFile /data/ssl/rootCA.pem --tlsCertificateKeyFile /data/ssl/mongodb.pem --tlsAllowInvalidCertificates"
docker-compose -f "mongo1/docker-compose.yml" exec -T mongo1 /scripts/wait-for-mongodb.sh "mongo1:27017" "$M1_OPTS"
docker-compose -f "mongo2/docker-compose.yml" exec -T mongo2 /scripts/wait-for-mongodb.sh "mongo2:27018" "$M1_OPTS"
docker-compose -f "mongo3/docker-compose.yml" exec -T mongo3 /scripts/wait-for-mongodb.sh "mongo3:27019" "$M1_OPTS"

echo "Creating replica set..."
docker-compose -f "mongo1/docker-compose.yml" exec -T mongo1 /scripts/init.sh

sed -i  's/# //g' mongo1/config/mongodb.conf
sed -i  's/# //g' mongo2/config/mongodb.conf
sed -i  's/# //g' mongo3/config/mongodb.conf

docker-compose -f "mongo1/docker-compose.yml" restart
docker-compose -f "mongo2/docker-compose.yml" restart
docker-compose -f "mongo3/docker-compose.yml" restart


###########zookeeper##############

docker-compose -f "zookeeper1/docker-compose.yml" down
docker-compose -f "zookeeper2/docker-compose.yml" down
docker-compose -f "zookeeper3/docker-compose.yml" down

docker-compose -f "zookeeper1/docker-compose.yml" up -d
docker-compose -f "zookeeper2/docker-compose.yml" up -d
docker-compose -f "zookeeper3/docker-compose.yml" up -d

docker-compose -f "kafka-user-builder/docker-compose.yml" up -d

###########kafka###############

docker-compose -f "kafka1/docker-compose.yml" down
docker-compose -f "kafka2/docker-compose.yml" down
docker-compose -f "kafka3/docker-compose.yml" down

docker-compose -f "kafka1/docker-compose.yml" up -d
docker-compose -f "kafka2/docker-compose.yml" up -d
docker-compose -f "kafka3/docker-compose.yml" up -d

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

mkdir redis1/sentinel_conf
mkdir redis2/sentinel_conf
mkdir redis3/sentinel_conf

chmod 777 redis1/sentinel_conf
chmod 777 redis2/sentinel_conf
chmod 777 redis3/sentinel_conf

cp sentinel.conf redis1/sentinel_conf
cp sentinel.conf redis2/sentinel_conf
cp sentinel.conf redis3/sentinel_conf

chmod 777 redis1/sentinel_conf/sentinel.conf
chmod 777 redis2/sentinel_conf/sentinel.conf
chmod 777 redis3/sentinel_conf/sentinel.conf

sed -i 's/26379/26380/g' redis2/sentinel_conf/sentinel.conf
sed -i 's/26379/26381/g' redis3/sentinel_conf/sentinel.conf

docker-compose -f "redis1/docker-compose.yml" up -d
docker-compose -f "redis2/docker-compose.yml" up -d
docker-compose -f "redis3/docker-compose.yml" up -d

##########python############

docker-compose -f "python-project1-1/docker-compose.yml" down
docker-compose -f "python-project2-1/docker-compose.yml" down
docker-compose -f "python-project1-2/docker-compose.yml" down
docker-compose -f "python-project2-2/docker-compose.yml" down


docker-compose -f "python-project1-1/docker-compose.yml" up -d
docker-compose -f "python-project2-1/docker-compose.yml" up -d
docker-compose -f "python-project1-2/docker-compose.yml" up -d
docker-compose -f "python-project2-2/docker-compose.yml" up -d