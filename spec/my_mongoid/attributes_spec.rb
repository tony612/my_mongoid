require 'spec_helper'

describe MyMongoid::Attributes do
  let(:model) {
    Class.new do
      include MyMongoid::Document
      field :number
      def number=(n)
        self.attributes["number"] = n + 1
      end
    end
  }

  let(:attributes) {
    {"id" => "123", "number" => 10}
  }

  let(:event) {
    model.new(attributes)
  }

  it 'is a module' do
    expect(MyMongoid::Attributes).to be_a(Module)
  end

  it "can read the attributes of model" do
    expect(event.attributes).to eq({"id" => "123", "number" => 11})
  end

  describe '#read_attribute' do
    it 'can read attribute' do
      expect(event.read_attribute(:number)).to eql(11)
    end
  end

  describe '#write_attribute' do
    it 'can write attribute' do
      event.write_attribute(:id, "abc")
      expect(event.read_attribute(:id)).to eql("abc")
    end
  end

  describe '#process_attributes' do
    it "use field setters for mass-assignment" do
      event.process_attributes :number => 10
      expect(event.number).to eq(11)
    end

    it "raise MyMongoid::UnknownAttributeError if the attributes Hash contains undeclared fields." do
      expect {
        event.process_attributes :unkonwn => 10
      }.to raise_error(MyMongoid::UnknownAttributeError)
    end

    it "aliases #process_attributes as #attribute=" do
      expect(event.number).to eq(11)
    end

    it "uses #process_attributes for #initialize" do
      expect(event.number).to eq(11)
    end
  end

end
