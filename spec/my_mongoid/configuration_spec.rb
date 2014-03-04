require 'spec_helper'
describe MyMongoid::Configuration do
  it 'should be a singleton class' do
    expect {
      MyMongoid::Configuration.new
    }.to raise_error(NoMethodError)
    expect(MyMongoid::Configuration.instance).to eql(MyMongoid::Configuration.instance)
  end
  it 'should have #host accessor' do
    expect(MyMongoid::Configuration.instance).to respond_to(:host, :host=)
  end
  it 'should have #database accessor' do
    expect(MyMongoid::Configuration.instance).to respond_to(:database, :database=)
  end

  describe 'MyMongoid.configuration' do
    it 'should return the MyMongoid::Configuration singleton' do
      expect(MyMongoid.configuration).to eql(MyMongoid::Configuration.instance)
    end
  end

  describe 'MyMongoid.configure' do
    it 'should yield MyMongoid.configuration to a block' do
      MyMongoid.configure do |c|
        expect(c).to eql(MyMongoid.configuration)
      end
    end
  end

  describe 'MyMongoid.config?' do
    before(:each) do
      MyMongoid.configure do |config|
        config.host = "localhost:27017"
        config.database = "my_mongoid"
      end
    end
    it 'returns true when configured' do
      expect(MyMongoid.config?).to be true
    end
    it 'returns false without configuring host' do
      MyMongoid.configuration.host = nil
      expect(MyMongoid.config?).to be false
    end
    it 'returns false without configuring database' do
      MyMongoid.configuration.database = nil
      expect(MyMongoid.config?).to be false
    end
    it 'returns false without configuring both' do
      MyMongoid.configuration.database = nil
      MyMongoid.configuration.host = nil
      expect(MyMongoid.config?).to be false
    end
  end
end
