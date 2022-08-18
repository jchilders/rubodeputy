require "rubodeputy"
require "rubodeputy/deputy"

module Rubodeputy
  module Commands
    Registry = CLI::Kit::CommandRegistry.new(
      default: "help",
      contextual_resolver: nil
    )

    def self.register(const, cmd, path)
      autoload(const, path)
      Registry.add(->() { const_get(const) }, cmd)
    end

    register :Correct, "correct", "rubodeputy/commands/correct"
    register :Reset, "reset", "rubodeputy/commands/reset"
    register :Stats, "stats", "rubodeputy/commands/stats"
    register :Help, "help", "rubodeputy/commands/help"
  end
end
