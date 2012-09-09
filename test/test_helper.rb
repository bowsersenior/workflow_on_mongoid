require 'rubygems'
require 'bundler'
Bundler.setup

require 'test/unit'
require 'active_record'

require 'workflow_on_mongoid'

class << Test::Unit::TestCase
  def test(name, &block)
    test_name = :"test_#{name.gsub(' ','_')}"
    raise ArgumentError, "#{test_name} is already defined" if self.instance_methods.include? test_name.to_s
    if block
      define_method test_name, &block
    else
      puts "PENDING: #{name}"
    end
  end
end

class ActiveRecordTestCase < Test::Unit::TestCase
  def exec(sql)
    ActiveRecord::Base.connection.execute sql
  end

  def setup
    ActiveRecord::Base.establish_connection(
      :adapter => "sqlite3",
      :database  => ":memory:" #"tmp/test"
    )

    # eliminate ActiveRecord warning. TODO: delete as soon as ActiveRecord is fixed
    ActiveRecord::Base.connection.reconnect!
  end

  def teardown
    ActiveRecord::Base.connection.disconnect!
  end

  def default_test
  end
end

require 'mongoid'
class MongoidTestCase < Test::Unit::TestCase
  Mongoid.configure do |config|
    if config.respond_to?(:connect_to)  # 3.x
      config.connect_to("workflow_on_mongoid")
    else                                # 2.x
      config.master = Mongo::Connection.new('127.0.0.1', 27017).db("workflow_on_momgoid")
    end
  end

  def teardown
    if Mongoid.respond_to?(:purge!) # 3.x
      Mongoid.purge!
    else                            # 2.x
      Mongoid.master.collections.select do |collection|
        collection.name !~ /system/
      end.each(&:drop)
    end
  end

  def default_test; end
end