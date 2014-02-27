require 'spec_helper'

describe MyMongoid::Field do
  let(:model) {
    Class.new do
      include MyMongoid::Document

      field :public
      field :created_at, :default => Time.parse("2014-01-01")
      field :number, :as => :n, :type => Integer
    end
  }

  it 'is a module' do
    expect(MyMongoid::Field).to be_a(Module)
  end

  describe '.field' do
    let(:attrs) {
      {:public => true, :created_at => Time.parse("2014-01-01")}
    }
    let(:event) {
      model.new(attrs)
    }
    it 'defines accessor methods' do
      expect(event).to respond_to(:public)
      expect(event.public).to eql(true)
      expect(event).to respond_to(:public=)
      event.public = false
      expect(event.public).to eql(false)
    end

    context 'when field is declared twice' do
      it 'raises DuplicateFieldError' do
        expect {
          model.module_eval do
            field :public
          end
        }.to raise_error(MyMongoid::DuplicateFieldError)
      end
    end

    it 'add a field object to fields' do
      expect(model.fields['public']).to be_a(MyMongoid::Field)
    end

    context 'parse options' do
      it "stores the field options in Field object" do
        expect(model.fields["number"].options).to include(:as => :n)
      end

      it 'aliases a field with :as option' do
        event = model.new(number: 10)
        expect(event.number).to eq(10)
        expect(event.n).to eq(10)
        event.n = 20
        expect(event.number).to eq(20)
        expect(event.n).to eq(20)
      end

      it "set default value with :default option" do
        event = model.new({})
        expect(event.created_at).to eq(Time.parse("2014-01-01"))
      end

      it "specify type for :type option" do
        expect {
          model.new({number: "foo"})
        }.to raise_error(MyMongoid::AttributeTypeError)
      end
    end
  end

  describe '.fields' do
    let(:fields) {
      model.fields
    }
    it 'maintains a map fields objects' do
      expect(fields).to be_a(Hash)
      expect(fields.keys).to include(*%w(public created_at))
    end

    it 'has a default field _id' do
      expect(fields.keys).to include('_id')
    end

    it 'returns a string for Field#name' do
      field = fields["public"]
      expect(field).to be_a(MyMongoid::Field)
      expect(field.name).to eq("public")
    end
  end

  describe 'included' do
    it 'define id field' do
      expect(model.fields).to include('id')
    end

    it 'alias _id as id as default' do
      event = model.new
      event.id = "abc"
      expect(event._id).to eq("abc")
    end
  end

  describe '.alias_methods' do
    it 'maintains aliased methods' do
      expect(model.alias_methods).to be_a(Hash)
      expect(model.alias_methods).to include('n' => 'number', '_id' => 'id')
    end
  end

  describe '.default_attributes' do
    it 'maintains default methods' do
      expect(model.default_attributes).to be_a(Hash)
      expect(model.default_attributes).to include('created_at' => Time.parse('2014-01-01'))
    end
  end

  describe '.field_types' do
    it 'maintains field types' do
      expect(model.field_types).to be_a(Hash)
      expect(model.field_types).to include('number' => Integer)
    end
  end
end
