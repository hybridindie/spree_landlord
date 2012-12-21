RSpec::Matchers.define :run_without_errors do
  match do |shell_command|
    @output, status = Open3.capture2e(shell_command)
    status.success?
  end

  failure_message_for_should do |shell_command|
    "expected that #{shell_command} would run without errors.\nFull output log follows:\n" + @output
  end

  failure_message_for_should_not do |shell_command|
    "expected that #{shell_command} would run with errors.\nFull output log follows:\n" + @output
  end

  description do
    "be a successful shell command"
  end
end
