require 'spec_helper'

describe MyMongoid::Callbacks do
  prepare_database
  let(:klass) {
    Class.new {
      include MyMongoid::Document

      def self.name
        self.to_s
      end

      def self.to_s
        "Event"
      end
    }
  }
  after do
    klass.collection.drop
  end

  describe 'declare hooks' do
    context 'with before, arount and after' do
      [:delete,:save,:create,:update].each do |name|
        it "should declare before hook for #{name}" do
          expect(klass).to respond_to("before_#{name}")
        end

        it "should declare around hook for #{name}" do
          expect(klass).to respond_to("around_#{name}")
        end

        it "should declare after hook for #{name}" do
          expect(klass).to respond_to("after_#{name}")
        end
      end
    end
    context 'with after' do
      [:find,:initialize].each do |name|
        it "should not declare before hook for #{name}" do
          expect(klass).to_not respond_to("before_#{name}")
        end

        it "should not declare around hook for #{name}" do
          expect(klass).to_not respond_to("around_#{name}")
        end

        it "should declare after hook for #{name}" do
          expect(klass).to respond_to("after_#{name}")
        end
      end
    end
  end
end
