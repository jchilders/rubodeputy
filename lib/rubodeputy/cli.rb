# frozen_string_literal: true

require "thor"
require "rubodeputy/deputy"

module Rubodeputy
  class CLI < Thor
    desc "clean <dir>",
      "Run Rubocop's autocorrect on each subdirectory of <dir>, run tests, then add to git if the tests pass."
    def clean(dir)
      Rubodeputy::Deputy.new(dir).clean!
    end
  end
end
