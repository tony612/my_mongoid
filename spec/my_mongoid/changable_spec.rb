require 'spec_helper'

describe MyMongoid::Changable do
  prepare_database

  let(:model) {
    Class.new do
      include MyMongoid::Document

      field :first_name
      field :last_name
    end
  }
  after(:all) do
    model.collection.drop
  end

  describe '#changed_attributes' do
    it "should be an empty hash initially" do
      person = model.new(first_name: "A", last_name: "B")
      expect(person.changed_attributes).to eql({})
    end
    it "should track writes to attributes" do
      person = model.new(first_name: "A", last_name: "B")
      person.first_name = "C"
      person.last_name = "D"
      expect(person.changed_attributes["first_name"][1]).to eql("C")
      expect(person.changed_attributes["last_name"][1]).to eql("D")
    end
    it "should keep the original attribute values" do
      person = model.new(first_name: "A", last_name: "B")
      person.first_name = "C"
      person.last_name = "D"
      expect(person.changed_attributes["first_name"][0]).to eql("A")
      expect(person.changed_attributes["last_name"][0]).to eql("B")
    end
    it "should not make a field dirty if the assigned value is equaled to the old value" do
      person = model.new(first_name: "A")
      person.first_name = "A"
      expect(person.changed_attributes['first_name']).to be_nil
    end
  end

  describe '#clear_changed' do
    it 'set changed_attributes empty' do
      person = model.new(first_name: "A", last_name: "B")
      person.clear_changed
      expect(person.changed_attributes).to eql({})
    end
  end

  describe '#changed?' do
    it 'should be false for a newly instantiated record' do
      person = model.new(first_name: "A")
      expect(person.changed?).to be false
    end
    it "should be true if a field changed" do
      person = model.new(first_name: "A", last_name: "B")
      person.first_name = "C"
      expect(person.changed?).to be true
    end
  end
end
