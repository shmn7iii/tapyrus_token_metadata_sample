# Tapyrus Token with Metadata Sample

Ruby: 3.1.2  
Rails: 7.0.1.2

## setup

required: nodejs, yarn, docker, docker-compose

```bash
# setup bundle, database, and so on.
$ ./bin/setup

# start containers. this include tails, tapyrusd, ipfs.
$ docker-compose up

# ttms init
$ docker-compose exec rails rails ttms:init

# restart
$ docker-compose restart
```
