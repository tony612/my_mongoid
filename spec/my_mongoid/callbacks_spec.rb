require 'spec_helper'

describe MyMongoid::Callbacks do
  prepare_database
  let(:klass) {
    Class.new {
      include MyMongoid::Document

      before_create :before_creating
      before_save :before_saving

      def before_creating; end
      def before_saving; end
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


  describe 'run create callbacks' do
    context 'when saving a new record' do
      let(:record) {
        klass.new
      }
      it 'runs creating callbacks' do
        expect(record).to receive(:before_creating)
        record.save
      end
      it 'runs saving callbacks' do
        expect(record).to receive(:before_saving)
        record.save
      end
    end
    context 'when creating a new record' do
      it 'runs creating callbacks' do
        expect_any_instance_of(klass).to receive(:before_creating)
        klass.create
      end
      it 'runs saving callbacks' do
        expect_any_instance_of(klass).to receive(:before_saving)
        klass.create
      end
    end
    context 'when saving a persisted record' do
      it 'runs only saving callbacks' do
        record = klass.create
        expect(record).to receive(:before_saving)
        expect(record).not_to receive(:before_creating)
        record.save
      end
    end
  end
end
