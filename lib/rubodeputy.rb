require "cli/ui"
require "cli/kit"

require "application"
require "rubodeputy/deputy"
require "rubodeputy/marshaler"
require "rubodeputy/correct_transaction"
require "rubodeputy/progress_listener"
require "rubodeputy/run_tests_transaction"

CLI::UI::StdoutRouter.enable

module Rubodeputy
  extend CLI::Kit::Autocall

  TOOL_NAME = "rubodeputy"
  ROOT      = File.expand_path("../..", __FILE__)
  LOG_FILE  = "/tmp/rubodeputy.log"

  autoload(:EntryPoint, "rubodeputy/entry_point")
  autoload(:Commands,   "rubodeputy/commands")

  autocall(:Config)  { CLI::Kit::Config.new(tool_name: TOOL_NAME) }
  autocall(:Command) { CLI::Kit::BaseCommand }

  autocall(:Executor) { CLI::Kit::Executor.new(log_file: LOG_FILE) }
  autocall(:Resolver) do
    CLI::Kit::Resolver.new(
      tool_name: TOOL_NAME,
      command_registry: Rubodeputy::Commands::Registry
    )
  end

  autocall(:ErrorHandler) do
    CLI::Kit::ErrorHandler.new(
      log_file: LOG_FILE,
      exception_reporter: nil
    )
  end
end
