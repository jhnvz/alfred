require 'spec_helper'
require 'generators/alfred/controller/controller_generator'

describe Alfred::Generators::ControllerGenerator do

  destination File.expand_path("../../../../tmp", __FILE__)

  before do
    prepare_destination
    run_generator %w(api/v1/posts)
  end

  subject { file('spec/alfreds/api/v1/posts_controller.rb') }

  it 'should exist' do
    subject.should exist
  end

  it 'should contain controller name' do
    File.read(subject).should include('controller Api::V1::PostsController')
  end

end