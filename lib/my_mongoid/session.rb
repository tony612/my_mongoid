require 'moped'

module MyMongoid
  def self.session
    raise UnconfiguredDatabaseError unless MyMongoid.config?
    @session ||= ::Moped::Session.new([MyMongoid.configuration.host])
  end
end
