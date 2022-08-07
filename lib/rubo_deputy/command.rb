# frozen_string_literal: true

require "thor"

module RuboDeputy
  class Command < Thor
    desc "hello NAME", "say hello to NAME"
    def hello(name)
      puts "Hello #{name}"
    end
  end
end
