# frozen_string_literal: true

require "thor"
require "rubodeputy/deputy"

module Rubodeputy
  class CLI < Thor
    desc "correct <dir>",
      "Run Rubocop's autocorrect on each subdirectory of <dir>, run tests, then add to git if the tests pass."
    def correct(dir = ".")
      Rubodeputy::Deputy.new(dir).clean!
    end

    desc "stats", "Print latest results"
    method_options verbose: :boolean, desc: "Print directory details"
    def stats
      Rubodeputy::Deputy.new.print_stats(options)
    end

    desc "reset", "Remove progress file"
    def reset
      Rubodeputy::Deputy.new.reset!
    end
  end
end
