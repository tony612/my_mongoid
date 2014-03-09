require 'spec_helper'

describe MyMongoid::Creatable do
  before(:all) do
    class Event
      include MyMongoid::Document

      field :created_at
    end
  end
  after(:all) do
    Object.send(:remove_const, :Event)
  end
  prepare_database
  describe '#save' do
    context 'when not persisted' do
      it 'update the db' do
        event = Event.create({created_at: 'bar'})
        expect(event).to receive(:update_document)
        event.created_at = "abc"
        event.save
      end
    end
    context 'when persisted' do
      it 'receive :insert' do
        event = Event.new({created_at: 'bar'})
        expect(event).to receive(:insert)
        event.save
      end
      it 'inserts a new record into the db' do
        col = Event.collection
        count = col.find.count
        event = Event.new({created_at: 'bar'})
        event.save
        expect(col.find.count).to eql(count + 1)
      end
      it 'returns true' do
        event = Event.new({created_at: 'bar'})
        expect(event.save).to be true
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
