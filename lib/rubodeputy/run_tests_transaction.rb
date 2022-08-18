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
        Dir.exist?(dir)
      end

      def run_tests(dir)
        tests = test_files(dir)
        return Failure(dir) unless tests.any?

        puts "-=> #{self.class.name}##{__method__} -> tests: #{tests}"
        `rake test #{tests.join(" ")}`
        if $CHILD_STATUS.success?
          Success(dir)
        else
          Failure(dir)
        end
      end

      def test_files(dir)
        files = files_for_dir(dir)
        [].tap do |ary|
          files.each do |file|
            ary << `alt #{file}`
          end
        end
      end
  end
end
