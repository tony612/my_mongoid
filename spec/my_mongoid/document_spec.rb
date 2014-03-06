require 'spec_helper'

describe MyMongoid::Document do
  let(:model) {
    Class.new do
      include MyMongoid::Document

      field :created_at
    end
  }

  it 'is a module' do
    expect(MyMongoid::Document).to be_a(Module)
  end

  describe '.is_mongoid_model?' do
    it 'returns true' do
      expect(model.is_mongoid_model?).to be(true)
    end
  end

  describe '#new_record?' do
    it 'returns true' do
      expect(model.new.new_record?).to be(true)
    end
  end

  describe '#initialize' do
    it 'accepts a hash' do
      expect(model.new({})).to be_a(model)
    end

    it 'raises ArgumentError when passed a non-hash' do
      expect {
        model.new("foo")
      }.to raise_error(ArgumentError)
    end

    it 'process_attributes' do
      event = model.new
      expect(event).to receive(:process_attributes)
      event.send(:initialize)
    end

    it 'accepts a block to operate the object' do
      event_block = nil
      event = model.new do |e|
        event_block = e
      end
      expect(event).to eql(event_block)
    end

  end

  describe '#to_document' do
    it 'should be a bson document' do
      doc = {created_at: "bar", _id: "abc"}
      event = model.new(doc)
      expect(event.to_document).to eql({"created_at" => "bar", "_id" => "abc"})
    end
  end

  describe '.instantiate' do
    it 'returns a model instance' do
      expect(model.instantiate).to be_a(model)
    end
    it "returns an instance that's not a new_record" do
      event = model.instantiate
      expect(event.new_record?).to be false
    end
    it 'has the given attributes' do
      event = model.instantiate(:created_at => "abc")
      expect(event.created_at).to eql("abc")
    end
  end
end
