# encoding: utf-8

require 'mysql2'
require 'tempfile'

###### config start
host = "localhost" # req
database = "fluentd" # req
username = "root" # req
password = "yywx27" # req
tablename = "test" # req
columns = "txt,txt2" # option
data_file_path = "/Users/fukui_retu/myhome/dev/workspaces/fluent-plugin-mysql-load/exsamples/testdata.txt" # これは本来はいらない
fields_delimiter = "," # option.(default:",")いらない
fields_enclosed_optionally = true # option いらない
fields_enclosed = '"' # optionいらない
fields_escaped = '\\\\' # option いらない
lines_terminated = "\n" # option .(default:"¥n")いらない
lines_starting = ">" # option いらない
ignore_lines = 1 # optionいらない
###### config end

client ||= Mysql2::Client.new(:host => host, :username => username, :password => password, :database => database)
client.query("SELECT * FROM test").each do |r|
  puts r
end

# load data in fileを試す
query = "LOAD DATA INFILE \"#{data_file_path}\" INTO TABLE #{tablename}"
query += " FIELDS TERMINATED BY '#{fields_delimiter}' ENCLOSED BY '#{fields_enclosed}' ESCAPED BY '#{fields_escaped}'" 
query += " LINES TERMINATED BY '#{lines_terminated}' STARTING BY '#{lines_starting}'"
query += " IGNORE #{ignore_lines} LINES"
query += " (#{columns})"
print query

result = client.query(query);