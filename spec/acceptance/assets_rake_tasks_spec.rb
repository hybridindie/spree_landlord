require 'spec_helper'

describe 'assets rake tasks' do
  context 'rake assets:precompile and rake assets:clean' do
    it 'runs without errors' do
      shell_command = 'cd spec/dummy && bundle && bundle exec rake assets:precompile && bundle exec rake assets:clean'
      shell_command.should run_without_errors
    end
  end

  context 'rake tenants:assets:precompile and rake tenants:assets:clean' do
    it 'runs without errors' do
      shell_command = 'cd spec/dummy && bundle && bundle exec rake tenants:assets:precompile && bundle exec rake tenants:assets:clean'
      shell_command.should run_without_errors
    end
  end
end
