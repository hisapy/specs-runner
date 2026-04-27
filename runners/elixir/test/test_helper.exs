formatters =
  if System.get_env("DEBUG_EXUNIT_TEST_STRUCT") == "1" do
    [ExUnit.CLIFormatter, SpecsRunner.ExUnitDebugFormatter]
  else
    [ExUnit.CLIFormatter]
  end

ExUnit.start(formatters: formatters)
