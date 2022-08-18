require "json"
require "rubodeputy"
require "rubodeputy/marshaler"

module Rubodeputy
  module Commands
    class Stats < Rubodeputy::Command
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

        def progress
          Application[:progress].progress
        end

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
          progress.each do |k, v|
            puts "#{k}: #{v.size}"
          end
        end
    end
  end
end
