require 'spec_helper'
describe MyMongoid::Sessions do
  prepare_database
  describe 'MyMongoid.session' do
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
    before(:all) do
      class Event
        include MyMongoid::Document

        field :created_at
      end
    end
    after(:all) do
      Object.send(:remove_const, :Event)
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
