require 'json'
require 'rubodeputy'
require 'rubodeputy/marshaler'

module Rubodeputy
  module Commands
    class Stats < Rubodeputy::Command
      attr_accessor :progress

      def call(args, _name)
        @progress = Rubodeputy::Marshaler.unmarshal_progress

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
        require 'json'
        progress_json = {}.tap do |hash|
          progress.each do |k, v|
            hash[k] = v.to_a
          end
        end
        puts progress_json
      end

      def print_stats(options = {})
        puts "Num dirs with Rubocop errors: #{progress[:err_dirs].size}"
        puts "Num dirs with test failures: #{progress[:failed_dirs].size}"
        puts "Num completed dirs: #{progress[:done_dirs].size}"
      end
    end
  end
end
