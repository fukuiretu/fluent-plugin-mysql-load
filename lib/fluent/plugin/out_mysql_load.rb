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
    config_param :tablename, :string, :default => nil
    config_param :columns, :string, :default => nil
    config_param :encoding, :string, :default => 'utf8'

    def configure(conf)
      super
      if @database.nil? || @tablename.nil?
        raise Fluent::ConfigError, "database and tablename is required!"
      end

      if (!@columns.nil?)
        @columns = @columns.split(",")
      end
    end

    def start
      super
    end

    def shutdown
      super
    end

    def format(tag, time, record)
      record.to_msgpack
    end

    def write(chunk)
      tmp = Tempfile.new("loaddata")
      keys = nil
      chunk.msgpack_each { |record|
        # keyの取得は初回のみ
        if keys.nil?
          # columnsが指定されている場合はそっちを有効にする
          keys = @columns.nil? ? record.keys : @columns
        end

        values = []
        keys.each{ |key|
          values << record[key]
        }

        tmp.write values.join("\t") + "\n"
      }
      tmp.close

      query = QUERY_TEMPLATE % ([tmp.path, @tablename, keys.join(",")])

      conn = get_connection
      conn.query(query)
      conn.close
    end

    private
    def get_connection
        Mysql2::Client.new({
            :host => @host,
            :port => @port,
            :username => @username,
            :password => @password,
            :database => @database,
            :encoding => @encoding
          })
    end
  end
end
