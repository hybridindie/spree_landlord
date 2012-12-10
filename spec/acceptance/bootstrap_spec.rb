require 'spec_helper'
require 'open3'

describe 'bootstrap' do
  describe 'a spree site with landlord installed' do
    context 'without a database' do
      it 'runs without errors' do
        commands = "y
        y
        "
        output, status = Open3.capture2e('cd spec/dummy && bundle && bundle exec rake db:drop && bundle exec rake db:bootstrap', :stdin_data => commands)
        status.should be_success
      end
    end

    context 'with a database' do
      it 'runs without errors' do
        commands = "y
        y
        "
        output, status = Open3.capture2e('cd spec/dummy && bundle && bundle exec rake db:drop && bundle exec rake db:migrate && bundle exec rake db:bootstrap', :stdin_data => commands)
        status.should be_success
      end
    end
  end
end
