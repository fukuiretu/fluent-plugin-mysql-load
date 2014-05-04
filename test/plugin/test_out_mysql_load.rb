require 'helper'

class MysqlLoadOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    password yywx27
    database fluentd
    tablename test
  ]

  def create_driver(conf = CONFIG, tag='test')
    Fluent::Test::BufferedOutputTestDriver.new(Fluent::MysqlLoadOutput, tag).configure(conf)
  end

  def test_configure_default
    d = create_driver
    
    assert_equal 'localhost', d.instance.host
    assert_equal 3306, d.instance.port
    assert_equal 'root', d.instance.username
    assert_equal 'utf8', d.instance.encoding
  end

  def test_configure_custom
    d = create_driver %[
      host abcde
      port 33306
      username taro
      password pldoeudku
      database db
      encoding sjis
      tablename test
      columns a,b,c,d,e
    ]
    
    assert_equal 'abcde', d.instance.host
    assert_equal 33306, d.instance.port
    assert_equal 'taro', d.instance.username
    assert_equal 'pldoeudku', d.instance.password
    assert_equal 'db', d.instance.database
    assert_equal 'sjis', d.instance.encoding
    assert_equal 'test', d.instance.tablename
    assert_equal ['a', 'b', 'c', 'd', 'e'], d.instance.columns
  end

  def test_configure_error
    assert_raise(Fluent::ConfigError) do
      create_driver %[
        host abcde
        port 33306
        username taro
        password pldoeudku
        encoding sjis
        tablename test
        columns a,b,c,d,e
      ]
    end

    assert_raise(Fluent::ConfigError) do
      create_driver %[
        host abcde
        port 33306
        username taro
        database db
        encoding sjis
        tablename test
        columns a,b,c,d,e
      ]
    end

    assert_raise(Fluent::ConfigError) do
      create_driver %[
        host abcde
        port 33306
        username taro
        password pldoeudku
        database db
        encoding sjis
        columns a,b,c,d,e
      ]
    end
  end

  def test_format
    d = create_driver

    d.emit({"id"=>1, "txt" => "hoge", "txt2" => "foo"})
    d.emit({"id"=>2, "txt" => "hoge2", "txt2" => "foo2"})

    d.expect_format({"id"=>1, "txt" => "hoge", "txt2" => "foo"}.to_msgpack)
    d.expect_format({"id"=>2, "txt" => "hoge2", "txt2" => "foo2"}.to_msgpack)

    d.run
  end

  def test_write
    # TODO
  end
end