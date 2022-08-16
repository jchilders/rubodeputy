# frozen_string_literal: true

require "dry/transaction"

module Rubodeputy
  class RunTestsTransaction
    include Dry::Transaction
    include Rubodeputy::DirWalker

    attr_accessor :test_dir

    check :valid?
    step :run_tests

    private

    def valid?(dir)
      puts "-=> #{self.class.name}##{__method__} -> dir: #{dir}"
      Dir.exist?(dir)
    end

    def run_tests(dir)
      puts "-=> #{self.class.name}##{__method__} -> running tests"
      files = files_for_dir(dir).join(" ")
      Success(dir)
    end
  end
end
