require 'spec_helper'

describe Alfred do

  describe '.configuration' do

    it 'should return new or existing instance of configuration' do
      Alfred.configuration.mock_with :rr
      Alfred.configuration.mock_with.should == :rr
    end

  end

  describe '.config' do

    it 'should yield configuration instance' do
      Alfred.configure do |c|
        c.mock_with :rr
      end
      Alfred.configuration.mock_with.should == :rr
    end

  end

  describe '.registry' do

    it 'should return new or existing instance of registry' do
      Alfred.registry.register('id', 'item')
      Alfred.registry['id'].should == ['item']
    end

  end

  describe '.include_modules!' do

    it 'should include configured modules in Request' do
      Alfred.configure { |c| c.include TestModule }

      Alfred::Request.should_receive(:include).with(TestModule)
      Alfred.include_modules!
    end

  end

end
