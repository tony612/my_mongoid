require 'spec_helper'

class Event
  include MyMongoid::Document
end

describe MyMongoid::Document do
  it 'is a module' do
    expect(MyMongoid::Document).to be_a(Module)
  end

  describe '.is_mongoid_model?' do
    it 'returns true' do
      expect(Event.is_mongoid_model?).to be(true)
    end
  end

  describe '#new_record?' do
    it 'returns true' do
      expect(Event.new.new_record?).to be(true)
    end
  end

  describe '#initialize' do
    it 'accepts a hash' do
      expect(Event.new({})).to be_a(Event)
    end

    it 'raises ArgumentError when passed a non-hash' do
      expect {
        Event.new("foo")
      }.to raise_error(ArgumentError)
    end

    it 'process_attributes' do
      event = Event.new
      expect(event).to receive(:process_attributes)
      event.send(:initialize)
    end

    it 'accepts a block to operate the object' do
      event_block = nil
      event = Event.new do |e|
        event_block = e
      end
      expect(event).to eql(event_block)
    end

  end

  describe '#to_document' do
    it 'should be a bson document' do
      doc = {created_at: "bar"}
      event = Event.new(doc)
      expect(event.to_document).to eql({"created_at" => "bar"})
    end
  end
end
