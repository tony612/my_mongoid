module MyMongoid
  class Configuration
    include Singleton

    attr_accessor :host
    attr_accessor :database
  end

  def self.configuration
    Configuration.instance
  end

  def self.configure
    yield configuration if block_given?
  end

  def self.config?
    !!(MyMongoid.configuration.host && MyMongoid.configuration.database)
  end
end
