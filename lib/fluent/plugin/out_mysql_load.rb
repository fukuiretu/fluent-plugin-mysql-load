class Fluent::MysqlLoadOutput < Fluent::BufferedOutput
  Fluent::Plugin.register_output('mysql_load', self)
  
  def initialize
    require 'mysql2'
    super
  end

  def configure(conf)
    super
    # @path = conf['path']
  end

  def start
    super
    # init
  end

  def shutdown
    super
    # destroy
  end

  def format(tag, time, record)
    [tag, time, record].to_msgpack
  end

  def write(chunk)
    records = []
    chunk.msgpack_each { |record|
      # records << record
    }
    # write records
  end
end