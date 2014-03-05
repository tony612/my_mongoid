require 'spec_helper'
describe MyMongoid::Sessions do
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
    it 'receives the config rightly' do
      MyMongoid.session.disconnect
      expect(MyMongoid.session.send(:current_database_name)).to eql(:none)
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

  describe 'MyMongoid::Document' do
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

    describe '#to_document' do
      it 'should be a bson document' do
        doc = {created_at: "bar"}
        event = Event.new(doc)
        expect(event.to_document).to eql({"created_at" => "bar"})
      end
    end

    describe '#save' do
      context 'successful insert' do
        it 'inserts a new record into the db' do
          col = Event.collection
          event = Event.new({created_at: 'bar'})
          expect(Event).to receive(:collection).and_return(col)
          expect(col).to receive(:insert).with({"created_at" => 'bar'})
          event.save
        end
        it 'returns true' do
          event = Event.new({created_at: 'bar'})
          expect(event.save).to include({"n"=>0, "err"=>nil, "ok"=>1.0})
        end
        it 'makes Model#new_record return false' do
          event = Event.new({created_at: 'bar'})
          expect(event.new_record?).to be true
          event.save
          expect(event.new_record?).to be false
        end
      end
    end
    describe '.create' do
      it 'returns a saved record' do
        event = Event.create({created_at: 'bar'})
        expect(event).not_to be_new_record
      end
    end
  end
end
