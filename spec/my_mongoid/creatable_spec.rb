require 'spec_helper'

describe MyMongoid::Creatable do
  before(:each) do
    MyMongoid.configure do |config|
      config.host = "localhost:27017"
      config.database = "my_mongoid"
    end
  end
  before(:all) do
    class Event
      include MyMongoid::Document

      field :created_at
    end
  end
  after(:all) do
    Object.send(:remove_const, :Event)
  end
  describe '#save' do
    context 'successful insert' do
      it 'inserts a new record into the db' do
        col = Event.collection
        event = Event.new({created_at: 'bar', _id: "abc"})
        expect(Event).to receive(:collection).and_return(col)
        expect(col).to receive(:insert).with({"created_at" => 'bar', "_id" => "abc"})
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
      it 'have no changes right after persisting' do
        event = Event.new({created_at: 'bar'})
        expect(event.changed?).to be false
        event.created_at = "foo"
        expect(event.changed?).to be true
        event.save
        expect(event.changed?).to be false
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
