require 'spec_helper'
describe MyMongoid do
  describe 'MyMongoid.session' do
    before(:each) do
      MyMongoid.configure do |config|
        config.host = "localhost:27017"
        config.database = "my_mongoid"
      end
    end
    it 'returns a Moped::Session' do
      expect(MyMongoid.session).to be_a(Moped::Session)
    end
    it 'memoizes the session @session' do
      expect(MyMongoid.session).to eql(MyMongoid.session)
    end
    it 'raises no errors if host and database are configured' do
      expect {
        MyMongoid.session
      }.not_to raise_error
    end
    it 'raises MyMongoid::UnconfiguredDatabaseError if host and database are not configured' do
      expect(MyMongoid).to receive(:config?).and_return(false)
      expect {
        MyMongoid.session
      }.to raise_error(MyMongoid::UnconfiguredDatabaseError)
    end
  end
end
