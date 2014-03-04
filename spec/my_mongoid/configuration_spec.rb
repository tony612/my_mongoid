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
end
