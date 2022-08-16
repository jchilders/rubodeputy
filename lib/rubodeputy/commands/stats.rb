require "json"
require "rubodeputy"
require "rubodeputy/marshaler"

module Rubodeputy
  module Commands
    class Stats < Rubodeputy::Command
      include Rubodeputy::Marshaler

      def call(args, _name)
        if args.include?("--json")
          print_json
          return
        end

        print_stats
      end

      class << self
        def help
          "Print stats.\nUsage: {{command:#{Rubodeputy::TOOL_NAME} stats}} [--json]"
        end
      end

      private

        def print_json
          require "json"
          result = {}.tap do |hash|
            progress.each do |k, v|
              hash[k] = v.to_a
            end
          end
          puts result.to_json
        end

        def print_stats(options = {})
          puts "Num dirs with Rubocop errors: #{progress[:err_dirs].size}"
          puts "Num dirs with test failures: #{progress[:failed_dirs].size}"
          puts "Num completed dirs: #{progress[:done_dirs].size}"
        end
    end
  end
end
