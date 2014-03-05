require 'spec_helper'

describe MyMongoid::Findable do
  let(:model) {
    Class.new do
      include MyMongoid::Document
    end
  }
  it 'is a module' do
    expect {
      MyMongoid::Findable.new
    }.to raise_error(NoMethodError)
  end
  describe '.find' do
    before(:each) do
      MyMongoid.configure do |config|
        config.host = "localhost:27017"
        config.database = "my_mongoid"
      end
    end
    after(:each) do
      MyMongoid.configure do |config|
        config.host = nil
        config.database = nil
      end
    end
    it 'can find a record by issuing query' do
      o = model.create
      result = model.find({"id" => o.id})
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
end
