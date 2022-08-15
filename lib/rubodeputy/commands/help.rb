require 'rubodeputy'

module Rubodeputy
  module Commands
    class Help < Rubodeputy::Command
      def call(args, _name)
        puts CLI::UI.fmt("{{bold:Available commands}}")
        puts ""

        Rubodeputy::Commands::Registry.resolved_commands.each do |name, klass|
          next if name == 'help'

          puts CLI::UI.fmt("{{command:#{Rubodeputy::TOOL_NAME} #{name}}}")
          if help = klass.help
            puts CLI::UI.fmt(help)
          end
          puts ""
        end
      end
    end
  end
end
