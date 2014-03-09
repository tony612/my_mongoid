require 'spec_helper'

describe MyMongoid::Deletable do
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
  describe '#delete' do
    it 'deletes a record from db' do
      person = model.create(created_at: "foo")
      expect(model.collection.find.sort(_id: -1).limit(-1).one['_id']).to eql(person.id)
      expect {
        person.delete
      }.to change{model.collection.find.count}.by(-1)


    end
    it 'returns true for deleted?' do

    end
  end
end
