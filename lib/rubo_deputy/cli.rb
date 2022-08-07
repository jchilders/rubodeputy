# frozen_string_literal: true

require "thor"
require "rubo_deputy/deputy"

module RuboDeputy
  class CLI < Thor
    desc "clean <dir>",
      "Run Rubocop's autocorrect on each subdirectory of <dir>, run tests, then add to git if the tests pass."
    def clean(dir)
      RuboDeputy::Deputy.new(dir).clean!
    end
  end
end
