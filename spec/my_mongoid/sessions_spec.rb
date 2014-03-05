require 'spec_helper'
describe MyMongoid::Sessions do
  describe 'MyMongoid.session' do
    before(:each) do
      MyMongoid.configure do |config|
        config.host = "localhost:27017"
        config.database = "my_mongoid"
      end
    end
    after(:each) do
      MyMongoid.configure do |config|
        config.host = nil
        config.database = nil
      end
    end
    it 'returns a Moped::Session' do
      expect(MyMongoid.session).to be_a(Moped::Session)
    end
    it 'memoizes the session @session' do
      expect(MyMongoid.session).to eql(MyMongoid.session)
    end
    it 'receives the config rightly' do
      MyMongoid.session.collection_names
      expect(MyMongoid.session.send(:current_database_name)).to eql("my_mongoid")
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

  describe 'collection' do
    class Event
      include MyMongoid::Document

      field :created_at
    end

    before(:each) do
      MyMongoid.configure do |config|
        config.host = "localhost:27017"
        config.database = "my_mongoid"
      end
    end

    describe '.collection_name' do
      it "uses active support's titleize method" do
        expect(Event.collection_name).to eql("events")
      end
    end

    describe '.collection' do
      it "returns a model's collection" do
        expect(Event.collection).to be_a(Moped::Collection)
        expect(Event.collection.name).to eql("events")
      end
    end
  end
end
