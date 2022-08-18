# frozen_string_literal: true

require "English"
require "dry/monads"
require "dry/monads/do"
require "dry/transaction"
require "set"
require "rubodeputy/dir_walker"
require "rubodeputy/marshaler"

module Rubodeputy
  class Deputy
    include Rubodeputy::DirWalker
    include Rubodeputy::Marshaler

    attr_accessor :dir_to_clean

    def initialize(dir_to_clean = ".")
      raise ArgumentError, "#{dir_to_clean} is not a directory" unless File.directory?(dir_to_clean)

      @dir_to_clean = dir_to_clean.gsub(%r{/$}, "") # rm trailing slash
    end

    def correct
      correct_subdirs
      run_tests
      # git_add
    end

    def correct_subdirs
      subdirs.each do |dir|
        Rubodeputy::CorrectTransaction.new.call(dir) do |on|
          on.success { |dir| corrected_dirs << dir }
          on.failure { |dir| err_dirs << dir }
        end
      end
    end

    def run_tests
      corrected_dirs.each do |dir|
        Rubodeputy::RunTestsTransaction.new.call(dir) do |on|
          on.success { |dir| tested_dirs << dir }
          on.failure { |dir| tests_failed_dirs << dir }
        end
      end
    end

    def progress
      Application[:progress].progress
    end

    def corrected_dirs
      progress[:corrected_dirs]
    end

    def err_dirs
      progress[:err_dirs]
    end

    def tested_dirs
      progress[:tested_dirs]
    end

    def tests_failed_dirs
      progress[:tests_failed_dirs]
    end

    # @return [Maybe]
    def lint_and_test(dir)
      if already_processed_dirs.member?(dir)
        Success(dir)
      else
        Failure(dir)
      end

      return if already_processed_dirs.member?(dir)

      autocorrect(dir)
      unless $CHILD_STATUS.success?
        add_error(dir)
        `git checkout #{dir}`

        nil
      end

      # # If nothing changed go to next dir
      # `git diff --quiet -- #{dir}`
      # if $CHILD_STATUS.success?
      #   add_done(dir)
      #   return
      # end

      # test_dir = dir.gsub(/^app/, "test")
      # if Dir.exist?(test_dir)
      #   `rake test #{test_dir}`
      # else
      #   `rake test`
      # end

      # unless $CHILD_STATUS.success?
      #   add_failure(dir)

      #   return
      # end

      # add_done(dir)
    end

    private

      def already_processed_dirs
        progress[:err_dirs] + progress[:failed_dirs] + progress[:done_dirs]
      end

      def autocorrect(dir_or_files)
        `rubocop --autocorrect --fail-level E #{dir_or_files}`
        if $CHILD_STATUS.success?
          Success(dir_or_files)
        else
          Failure(dir_or_files)
        end
      end

      def git_add
        progress[:done_dirs].each do |dir|
          `git add #{dir}`
        end
      end
  end
end
