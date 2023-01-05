#!/bin/bash

mongosh --tls \
  --tlsAllowInvalidCertificates \
  --tlsCAFile /data/ssl/rootCA.pem \
  --tlsCertificateKeyFile /data/ssl/mongodb.pem <<EOF
var config = {
    "_id": "dbrs",
    "version": 1,
    "members": [
        {
            "_id": 1,
            "host": "mongo1:27017",
            "priority": 3
        }
    ]
};
rs.initiate(config, { force: true });
rs.status();
EOF

mongosh --tls \
  --tlsAllowInvalidCertificates \
  --tlsCAFile /data/ssl/rootCA.pem \
  --tlsCertificateKeyFile /data/ssl/mongodb.pem <<EOF

rs.add({"_id": 2,"host": "mongo2:27017","priority": 2});
rs.add({"_id": 3,"host": "mongo3:27017","priority": 1});
rs.status();
EOF

mongosh --tls \
  --tlsAllowInvalidCertificates \
  --tlsCAFile /data/ssl/rootCA.pem \
  --tlsCertificateKeyFile /data/ssl/mongodb.pem <<EOF
  
use admin;
db.createUser( { user: "root",
          pwd: "pass",
          roles: [ "userAdminAnyDatabase",
                   "dbAdminAnyDatabase",
                   "readWriteAnyDatabase"

] } );
EOF