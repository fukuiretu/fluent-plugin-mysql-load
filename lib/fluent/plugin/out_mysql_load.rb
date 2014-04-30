class Fluent::MysqlLoadOutput < Fluent::BufferedOutput
  Fluent::Plugin.register_output('mysql_load', self)

  def initialize
    require 'mysql2'
    super
  end

  config_param :host, :string, :default => 'localhost'
  config_param :port, :integer, :default => 3306
  config_param :username, :string, :default => 'root'
  config_param :password, :string, :default => nil
  config_param :database, :string, :default => nil
  config_param :encoding, :string, :default => 'utf8'
  config_param :columns, string, :default => nil

  def configure(conf)
    super
    if password.nil? || database.nil?
      raise Fluent::ConfigError, "password and  database is required!"
    end
  end

  def start
    super
  end

  def shutdown
    super
  end

  def format(tag, time, record)
    [tag, time, record].to_msgpack
  end

  def write(chunk)
    # tmpファイルにvalueをTSVで出力する
    # keyはカンマ区切りの文字列にする
    # ただしcolumnsが指定されている場合、それに従う
    records = []
    chunk.msgpack_each { |record|
    }

    # load data infile のクエリを生成する
    query = ''
    # クエリを実行する
    connection = self.connection
    connection.query(query)
    connection.close
  end

  private
  def connection
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