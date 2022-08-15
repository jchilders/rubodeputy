require 'rubodeputy'
require 'rubodeputy/marshaler'

module Rubodeputy
  module Commands
    class Correct < Rubodeputy::Command
      def call(args, _name)
        dir = args[0]
        dep = Rubodeputy::Deputy.new(dir)
        dep.clean!
      end

      class << self
        def help
          "Clean directory.\nUsage: {{command:#{Rubodeputy::TOOL_NAME} clean}} <directory>"
        end
      end
    end
  end
end
