require 'spec_helper'

describe Alfred::Registry do

  let!(:registry) { Alfred::Registry.new }
  after(:each)    { registry.clear! }

  it 'should initialize with an empty hash for items' do
    registry.items.should == {}
  end

  describe '#register' do

    it 'should add an item to the registry' do
      registry.register('identifier', 'item')
      registry.items.should == { 'identifier' => ['item'] }

      registry.register('identifier', 'item2')
      registry.items.should == { 'identifier' => ['item', 'item2'] }
    end

  end

  describe '#registered?' do

    it 'should return true if identifier is found' do
      registry.register('identifier', 'item')
      registry.registered?('identifier').should be_true
    end

    it 'should return false if identifier is not found' do
      registry.register('identifier', 'item')
      registry.registered?('identifier1').should be_false
    end

  end

  describe '#find' do

    it 'should find items by identifier' do
      registry.register('identifier', 'item')
      registry.find('identifier').should == ['item']
    end

    it 'should return nil if identifier not registered' do
      registry.register('identifier', 'item')
      registry.find('identifier1').should be_nil
    end

    it 'should support [] syntax' do
      registry.register('identifier', 'item')
      registry['identifier'].should == ['item']
    end

  end

  describe '#all' do

    it 'should return all items in registry' do
      registry.register('identifier', 'item')
      registry.register('identifier1', 'item1')

      registry.all.should == ['item', 'item1']
    end

  end

  describe 'clear!' do

    it 'should clear all items' do
      registry.register('identifier', 'item')
      registry.clear!
      registry.items.should == {}
    end

  end

end
