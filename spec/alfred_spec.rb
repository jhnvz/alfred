require 'spec_helper'

describe Alfred do

  describe '.include_modules!' do

    it 'should include configured modules in Request' do
      Alfred.configure { |c| c.include TestModule }

      Alfred::Request.should_receive(:include).with(TestModule)
      Alfred.include_modules!
    end

  end

end
