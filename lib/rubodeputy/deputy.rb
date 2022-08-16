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
    include Dry::Monads[:result]
    include Rubodeputy::DirWalker
    include Rubodeputy::Marshaler

    attr_accessor :dir_to_clean

    def initialize(dir_to_clean = ".")
      @dir_to_clean = dir_to_clean.gsub(%r{/$}, "") # rm trailing slash
    end

    def correct
      correct_subdirs
      correct_root
      marshal_progress
      git_add
    end

    def correct_subdirs
      subdirs.each do |dir|
        result = Rubodeputy::CorrectTransaction.(dir)
      end
    end

    # include Dry::Transaction
    # include Dry::Monads::Do.for(:call)
    # def call(params)
    #   binding.pry
    # end

    def correct_root
      return unless root_dir_files.size.positive?

      file_list = root_dir_files.join(" ")
      autocorrect(file_list)

      unless $CHILD_STATUS.success?
        add_error(dir_to_clean)
        `git checkout #{file_list}`
        return
      end
      add_done(dir_to_clean)
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

      def add_error(dir)
        add_dir_progress(:err_dirs, dir)
      end

      def add_failure(dir)
        add_dir_progress(:failed_dirs, dir)
      end

      def add_done(dir)
        add_dir_progress(:done_dirs, dir)
      end

      def add_dir_progress(key, dir)
        return unless Dir.exist?(dir)

        progress[key] << dir
      end

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
