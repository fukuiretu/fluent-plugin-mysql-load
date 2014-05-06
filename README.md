# fluent-plugin-mysql-load, a plugin for [Fluentd](http://fluentd.org) [![Build Status](https://travis-ci.org/fukuiretu/fluent-plugin-mysql-load.svg?branch=master)](https://travis-ci.org/fukuiretu/fluent-plugin-mysql-load)


# Overview

fluent-plugin-mysql-load is a plugin fluentd.

BufferedOutput plugin to mysql import.
Internal processing uses the **"LOAD DATA LOCAL INFILE"**.

[Buffer Plugin Overview is here](http://docs.fluentd.org/articles/buffer-plugin-overview#buffer-plugin-overview)

[MySQL Manual of LOAD DATA is here](http://dev.mysql.com/doc/refman/5.6/en/load-data.html)

# Configuration
## Ex.
```
<match loaddata.**>
  type mysql_load
  host localhost
  port 3306
  username taro
  password abcdefg
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
loaddata.test: {"seq":111,"txt":"hoge","txt2":"foo","txt3":"bar","created_at":"2014-01-01 00:00:00"}
loaddata.test: {"seq":112,"txt":"hoge2","txt2":"foo2","txt3":"bar2","created_at":"2014-01-01 00:00:01"}
loaddata.test: {"seq":123,"txt":"hoge3","txt2":"foo3","txt3":"bar3","created_at":"2014-01-01 00:00:02"}
```

## Out.
```
mysql> desc test;
+-------+---------+------+-----+---------+----------------+
| Field | Type    | Null | Key | Default | Extra          |
+-------+---------+------+-----+---------+----------------+
| id    | int(11) | NO   | PRI | NULL    | auto_increment |
| txt   | text    | YES  |     | NULL    |                |
| txt2  | text    | YES  |     | NULL    |                |
| txt3  | text    | YES  |     | NULL    |                |
+-------+---------+------+-----+---------+----------------+

mysql> select * from test;
+---------------+------------------+---------------------+---------------------+
| id            | txt              | txt2                | txt3                |
+---------------+------------------+---------------------+---------------------+
| 1             | hoge             | foo                 | bar                 |
| 2             | hoge2            | foo2                | bar2                |
| 3             | hoge3            | foo3                | bar3                |
+---------------+------------------+---------------------+---------------------+
```

# Parameters

* **host** (option)

  Set the host name of MySQL Server.The default is "localhost".

* **port** (option)

  Set the port of MySQL Server.The default is "3306".

* **username** (option)

  Set the user of MySQL Server.The default is "root".

* **password** (option)

  Set the password of MySQL Server.The default is ""(blank).

* **database** (required)

  Set the database of MySQL Server.

* **tablename** (required)

  Set the table name of the import data.

* **columns** (option)

  Set if you want to specify the column of the table of data import destination.Attaches to the string key of the input data.

* **encoding** (option)

  Set the encode of MySQL Server.The default is "utf8".

And Buffer Plugin Parameters...

* [memory Buffer Plugin](http://docs.fluentd.org/articles/buf_memory)
* [file Buffer Plugin](http://docs.fluentd.org/articles/buf_file)

# Copyright
Copyright:: Copyright (c) 2014- Fukui ReTu License:: Apache License, Version 2.0
