MHRedis
=======

A key value storage system for iOS based on Redis

Usage
=======

Firstly 

    import "MHRedis.h"
  
And then

    MHRedis* redis = [[MHRedis alloc] init];
    [redis create];

Running Queries
=======

    [redis runQuery:@"COMMAND"];
  
Supported Commands
=======

* PING
* DBSIZE
* FLUSHDB
* SET (not fully implemented)
* GET
* APPEND
* DECR
* DECRBY
* GETRANGE
* GETSET
* INCRBY
* INCR
* MGET
* MSET
* MSETNX
* SETNX
* STRLEN
* EXISTS
* RANDOMKEY
* RENAME
* ECHO




