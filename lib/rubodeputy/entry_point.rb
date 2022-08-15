require 'rubodeputy'

module Rubodeputy
  module EntryPoint
    def self.call(args)
      cmd, command_name, args = Rubodeputy::Resolver.call(args)
      Rubodeputy::Executor.call(cmd, command_name, args)
    end
  end
end
