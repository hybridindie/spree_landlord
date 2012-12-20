require 'spec_helper'
require 'open3'

describe 'bootstrap' do
  describe 'a spree site with landlord installed' do
    context 'without a database' do
      it 'runs without errors' do
        shell_command = 'export AUTO_ACCEPT=true && cd spec/dummy && bundle && bundle exec rake db:drop && bundle exec rake db:bootstrap'
        shell_command.should run_without_errors
      end
    end

    context 'with a database' do
      it 'runs without errors' do
        shell_command = 'export AUTO_ACCEPT=true && cd spec/dummy && bundle && bundle exec rake db:drop && bundle exec rake db:migrate && bundle exec rake db:bootstrap'
        shell_command.should run_without_errors
      end
    end
  end
end
