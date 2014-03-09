require 'spec_helper'

describe MyMongoid::Updatable do
  prepare_database
  let(:model) {
    Class.new do
      include MyMongoid::Document

      field :created_at
    end
  }
  after(:all) do
    model.collection.drop
  end
  describe '#atomic_updates' do
    let(:obj) {
      model.new(created_at: "foo")
    }
    it 'should return {} if nothing changed' do
      obj.created_at = "abc"
      obj.save
      expect(obj.atomic_updates).to eql({})
    end
    it "should return {} if record is not a persisted document" do
      expect(obj.atomic_updates).to eql({})
    end
    it "should generate the $set update operation to update a persisted document" do
      obj.created_at = "abc"
      expect(obj.atomic_updates).to eql({"created_at" => "abc"})
    end
    it "should not consider id" do
      obj.id = "abc"
      expect(obj.atomic_updates).to eql({})
    end
  end

  describe '#update_document' do
    it 'should not issue query if nothing changed' do
      coll = model.collection
      obj = model.create(created_at: "foo")
      expect(obj).not_to receive(:update_attributes)
      obj.update_document
    end
    it 'should update the document in database if there are changes' do
      obj = model.create(created_at: "foo")
      expect(obj).to receive(:update_attributes).with({"created_at" => "abc"})
      obj.created_at = "abc"
      obj.update_document
    end
  end

  describe '#update_attributes' do
    it 'calls update method of obj' do
      coll = model.collection
      obj = model.create(created_at: "foo")
      expect(model).to receive(:collection).and_return(coll)
      expect(coll).to receive(:find).with({"_id" => obj.id}).and_return(obj)
      expect(obj).to receive(:update).with({created_at: "abc"})
      obj.update_attributes(created_at: "abc")
    end
  end
end
