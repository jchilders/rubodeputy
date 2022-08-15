require 'rubodeputy'

module Rubodeputy
  module Commands
    class Example < Rubodeputy::Command
      def call(_args, _name)
        puts 'neato'

        if rand < 0.05
          raise(CLI::Kit::Abort, "you got unlucky!")
        end
      end

      def self.help
        "A dummy command.\nUsage: {{command:#{Rubodeputy::TOOL_NAME} example}}"
      end
    end
  end
end
