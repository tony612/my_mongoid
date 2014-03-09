require 'spec_helper'

describe MyMongoid::Findable do
  let(:model) {
    Class.new do
      include MyMongoid::Document

      field :public
    end
  }
  it 'is a module' do
    expect {
      MyMongoid::Findable.new
    }.to raise_error(NoMethodError)
  end
  prepare_database
  describe '.find' do
    it 'can find a record by issuing query' do
      o = model.create
      result = model.find({"_id" => o.id})
      expect(result).to be_a(model)
      expect(result.id).to eql(o.id)
    end
    it 'can find a record by issuing shorthand id query' do
      o = model.create
      result = model.find(o.id)
      expect(result).to be_a(model)
      expect(result.id).to eql(o.id)
    end
    it 'raises MyMongoid::RecordNotFoundError if nothing is found for an id' do
      o = model.create
      expect {
        model.find("abc")
      }.to raise_error(MyMongoid::RecordNotFoundError)
    end
  end
  describe '#reload' do
    it 'reloads data from database' do
      o = model.create(public: true)
      expect(o.public).to be true
      o.public = false
      o.reload
      expect(o.public).to be true
    end
  end
end
