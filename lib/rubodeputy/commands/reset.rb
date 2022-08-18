require "json"
require "rubodeputy"
require "rubodeputy/marshaler"

module Rubodeputy
  module Commands
    class Reset < Rubodeputy::Command
      def call(args, _name)
        Application[:progress].reset
      end

      class << self
        def help
          "Reset progress.\nUsage: {{command:#{Rubodeputy::TOOL_NAME} reset}}"
        end
      end
    end
  end
end
