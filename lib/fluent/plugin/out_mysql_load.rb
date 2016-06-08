module Fluent
  class MysqlLoadOutput < Fluent::BufferedOutput
    Fluent::Plugin.register_output('mysql_load', self)

    QUERY_TEMPLATE = "LOAD DATA LOCAL INFILE '%s' INTO TABLE %s (%s)"

    # Define `log` method for v0.10.42 or earlier
    unless method_defined?(:log)
      define_method("log") { $log }
    end

    def initialize
      require 'mysql2'
      require 'tempfile'
      super
    end

    config_param :host, :string, :default => 'localhost'
    config_param :port, :integer, :default => 3306
    config_param :username, :string, :default => 'root'
    config_param :password, :string, :default => nil
    config_param :database, :string, :default => nil
    config_param :socket, :string, :default => '/tmp/mysql.sock'
    config_param :tablename, :string, :default => nil
    config_param :key_names, :string, :default => nil
    config_param :column_names, :string, :default => nil
    config_param :encoding, :string, :default => 'utf8'

    def configure(conf)
      super
      if @database.nil? || @tablename.nil? || @column_names.nil?
        raise Fluent::ConfigError, "database and tablename and column_names is required."
      end

      @key_names = @key_names.nil? ? @column_names.split(',') : @key_names.split(',')
      unless @column_names.split(',').count == @key_names.count
        raise Fluent::ConfigError, "It does not take the integrity of the key_names and column_names."
      end
    end

    def start
      super
    end

    def shutdown
      super
    end

    def format(tag, time, record)
      values = @key_names.map { |k|
        k == '${time}' ? Time.at(time).strftime('%Y-%m-%d %H:%M:%S') : record[k]
      }
      values.to_msgpack
    end

    def write(chunk)
      data_count = 0
      tmp = Tempfile.new("mysql-loaddata")
      chunk.msgpack_each { |record|
        tmp.write record.join("\t") + "\n"
        data_count += 1
      }
      tmp.close

      conn = get_connection
      conn.query(QUERY_TEMPLATE % ([tmp.path, @tablename, @column_names]))
      conn.close

      log.info "number that is registered in the \"%s:%s\" table is %d" % ([@database, @tablename, data_count])
    end

    private

    def get_connection
        Mysql2::Client.new({
            :host => @host,
            :port => @port,
            :username => @username,
            :password => @password,
            :database => @database,
            :socket => @socket,
            :encoding => @encoding,
            :local_infile => true
          })
    end
  end
end
