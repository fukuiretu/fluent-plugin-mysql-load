# fluent-plugin-mysql-load, a plugin for [Fluentd](http://fluentd.org)

[![Build Status](https://travis-ci.org/fukuiretu/fluent-plugin-mysql-load.svg?branch=master)](https://travis-ci.org/fukuiretu/fluent-plugin-mysql-load)
[![Gem Version](https://badge.fury.io/rb/fluent-plugin-mysql-load.svg)](http://badge.fury.io/rb/fluent-plugin-mysql-load)

# Overview

BufferedOutput plugin to mysql import.
Internal processing uses the **"LOAD DATA LOCAL INFILE"**.

[Buffer Plugin Overview is here](http://docs.fluentd.org/articles/buffer-plugin-overview#buffer-plugin-overview)

[MySQL Manual of LOAD DATA is here](http://dev.mysql.com/doc/refman/5.6/en/load-data.html)

# Configuration

## Ex1.
```
<match loaddata.**>
  type mysql_load
  host localhost
  port 3306
  username taro
  password abcdefg
  database fluentd
  tablename test
  column_names id,txt,txt2,txt3,created_at

  buffer_type file
  buffer_path /var/log/fluent/test.*.buffer
  flush_interval 60s
</match>
```

### In.
```
loaddata.test: {"id":111,"txt":"hoge","txt2":"foo","txt3":"bar","created_at":"2014-01-01 00:00:00"}
loaddata.test: {"id":112,"txt":"hoge2","txt2":"foo2","txt3":"bar2","created_at":"2014-01-01 00:00:01"}
loaddata.test: {"id":123,"txt":"hoge3","txt2":"foo3","txt3":"bar3","created_at":"2014-01-01 00:00:02"}
```

### Out.
```
mysql> desc test;
+------------+----------+------+-----+---------+----------------+
| Field      | Type     | Null | Key | Default | Extra          |
+------------+----------+------+-----+---------+----------------+
| id         | int(11)  | NO   | PRI | NULL    | auto_increment |
| txt        | text     | YES  |     | NULL    |                |
| txt2       | text     | YES  |     | NULL    |                |
| txt3       | text     | YES  |     | NULL    |                |
| created_at | datetime | YES  |     | NULL    |                |
+------------+----------+------+-----+---------+----------------+
mysql> select * from test;
+---------------+------------------+---------------------+---------------------+---------------------+
| id            | txt              | txt2                | txt3                |created_at           |
+---------------+------------------+---------------------+---------------------+---------------------+
| 111           | hoge             | foo                 | bar                 |2014-01-01 00:00:00  |
| 112           | hoge2            | foo2                | bar2                |2014-01-01 00:00:01  |
| 113           | hoge3            | foo3                | bar3                |2014-01-01 00:00:02  |
+---------------+------------------+---------------------+---------------------+---------------------+
```

## Ex2.
```
<match loaddata.**>
  type mysql_load
  host localhost
  port 3306
  username taro
  password abcdefg
  database fluentd
  tablename test
  key_names dummy1,dummy2,dummy3,create_d
  column_names txt,txt2,txt3,created_at

  buffer_type file
  buffer_path /var/log/fluent/test.*.buffer
  flush_interval 60s
</match>
```

### In.
```
loaddata.test: {"dummy1":"hoge","dummy2":"foo","dummy3":"bar","create_d":"2014-01-01 00:00:00"}
loaddata.test: {"dummy1":"hoge2","dummy2":"foo2","dummy3":"bar2","create_d":"2014-01-01 00:00:01"}
loaddata.test: {"dummy1":"hoge3","dummy2":"foo3","dummy3":"bar3","create_d":"2014-01-01 00:00:02"}
```

### Out.
```
mysql> desc test;
+------------+----------+------+-----+---------+----------------+
| Field      | Type     | Null | Key | Default | Extra          |
+------------+----------+------+-----+---------+----------------+
| id         | int(11)  | NO   | PRI | NULL    | auto_increment |
| txt        | text     | YES  |     | NULL    |                |
| txt2       | text     | YES  |     | NULL    |                |
| txt3       | text     | YES  |     | NULL    |                |
| created_at | datetime | YES  |     | NULL    |                |
+------------+----------+------+-----+---------+----------------+
mysql> select * from test;
+---------------+------------------+---------------------+---------------------+---------------------+
| id            | txt              | txt2                | txt3                |created_at           |
+---------------+------------------+---------------------+---------------------+---------------------+
| 1             | hoge             | foo                 | bar                 |2014-01-01 00:00:00  |
| 2             | hoge2            | foo2                | bar2                |2014-01-01 00:00:01  |
| 3             | hoge3            | foo3                | bar3                |2014-01-01 00:00:02  |
+---------------+------------------+---------------------+---------------------+---------------------+
```

## Ex3.
```
<match loaddata.**>
  type mysql_load
  host localhost
  port 3306
  username taro
  password abcdefg
  database fluentd
  tablename test
  key_names dummy1,dummy2,dummy3,${time}
  column_names txt,txt2,txt3,created_at

  buffer_type file
  buffer_path /var/log/fluent/test.*.buffer
  flush_interval 60s
</match>
```

### In.
```
loaddata.test: {"dummy1":"hoge","dummy2":"foo","dummy3":"bar"}
loaddata.test: {"dummy1":"hoge2","dummy2":"foo2","dummy3":"bar2"}
loaddata.test: {"dummy1":"hoge3","dummy2":"foo3","dummy3":"bar3"}
```

### Out.
```
mysql> desc test;
+------------+----------+------+-----+---------+----------------+
| Field      | Type     | Null | Key | Default | Extra          |
+------------+----------+------+-----+---------+----------------+
| id         | int(11)  | NO   | PRI | NULL    | auto_increment |
| txt        | text     | YES  |     | NULL    |                |
| txt2       | text     | YES  |     | NULL    |                |
| txt3       | text     | YES  |     | NULL    |                |
| created_at | datetime | YES  |     | NULL    |                |
+------------+----------+------+-----+---------+----------------+
mysql> select * from test;
+---------------+------------------+---------------------+---------------------+---------------------+
| id            | txt              | txt2                | txt3                |created_at           |
+---------------+------------------+---------------------+---------------------+---------------------+
| 1             | hoge             | foo                 | bar                 |2014-01-01 00:00:00  |
| 2             | hoge2            | foo2                | bar2                |2014-01-01 00:00:01  |
| 3             | hoge3            | foo3                | bar3                |2014-01-01 00:00:02  |
+---------------+------------------+---------------------+---------------------+---------------------+
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

* **key_names** (option)

  It is possible to specify the key for JSON input.

  Will be converted to a format in this embedding ${time}. (Format:'%Y-%m-%d %H:%M:%S')


* **column_names** (required)

  Set if you want to specify the column of the table of data import destination.

  If you do not specify a "key_names" parameters, to be used as a key input value of JSON the parameters specified in the "column_names".

* **encoding** (option)

  Set the encode of MySQL Server.The default is "utf8".

And Buffer Plugin Parameters...

* [memory Buffer Plugin](http://docs.fluentd.org/articles/buf_memory)
* [file Buffer Plugin](http://docs.fluentd.org/articles/buf_file)

And Logging of Fluentd Parameters...(>=v0.10.43)

 * [Logging of Fluentd](http://docs.fluentd.org/articles/logging#per-plugin-log-fluentd-v01043-and-above)


# ChangeLog

See [CHANGELOG.md](https://github.com/fukuiretu/fluent-plugin-mysql-load/blob/master/CHANGELOG.md) for details.

# Copyright
Copyright:: Copyright (c) 2014- Fukui ReTu License:: Apache License, Version 2.0
