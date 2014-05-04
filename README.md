# fluent-plugin-mysql-load, a plugin for [Fluentd](http://fluentd.org) [![Build Status](https://travis-ci.org/fukuiretu/fluent-plugin-mysql-load.svg?branch=master)](https://travis-ci.org/fukuiretu/fluent-plugin-mysql-load)


# Overview

"fluent-plugin-mysql-load" is a plugin fluentd.

Output filter plugin to mysql import.
Internal processing uses the "LOAD DATA INFILE".

[MySQL Manual of LOAD DATA is here](http://dev.mysql.com/doc/refman/5.6/en/load-data.html)

# Configuration
## Ex.
```
<match loaddata.**>
  type mysql_load
  password password
  database fluentd
  tablename test
  columns txt,txt2,txt3

  buffer_type file
  buffer_path /var/log/fluent/test.*.buffer
  flush_interval 60s
</match>
```

## In.
```
loaddata.test: {"seq":1,"txt":"hoge","txt2":"foo","txt3":"bar","createte_at":"2014-01-01 00:00:00"}
loaddata.test: {"seq":2,"txt":"hoge2","txt2":"foo2","txt3":"bar2","createte_at":"2014-01-01 00:00:01"}
loaddata.test: {"seq":3,"txt":"hoge3","txt2":"foo3","txt3":"bar3","createte_at":"2014-01-01 00:00:02"}
```

## Out.
```
  +------------------+---------------------+---------------------+
  | txt              | txt2                | txt3                |
  +------------------+---------------------+---------------------+
  | hoge             | foo                 | bar                 |
  | hoge2            | foo2                | bar2                |
  | hoge3            | foo3                | bar3                |
  +------------------+---------------------+---------------------+
```

# Parameters

* host(option)

  Set the host name of MySQL Server.The default is "localhost".

* port(option)

  Set the port of MySQL Server.The default is "3306".

* username(option)

  Set the user of MySQL Server.The default is "root".

* password(option)

  Set the password of MySQL Server.The default is ""(blank).

* database(required)

  Set the database of MySQL Server.

* tablename(required)

  Set the table name of the import data.

* columns(option)

  Set if you want to specify the column of the table of data import destination.Attaches to the string key of the input data.

* encoding(option)

  Set the encode of MySQL Server.The default is "utf8".


# Copyright
Copyright:: Copyright (c) 2014- Fukui ReTu License:: Apache License, Version 2.0
