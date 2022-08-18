require "json"
require "rubodeputy"
require "rubodeputy/marshaler"

module Rubodeputy
  module Commands
    class Correct < Rubodeputy::Command
      def call(args, _name)
        dir_to_clean = args[0]
        dep = Rubodeputy::Deputy.new(dir_to_clean)
        CLI::UI::Spinner.spin("Correcting: ") do |spinner|
          dep.subdirs.each do |dir|
            spinner.update_title(dir)
            dep.correct
          end
          spinner.update_title(dir_to_clean)
        end

        Rubodeputy::Commands::Stats.call([], nil)
      end

      class << self
        def help
          "Clean directory.\nUsage: {{command:#{Rubodeputy::TOOL_NAME} clean}} <directory>"
        end
      end
    end
  end
end
