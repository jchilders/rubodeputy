# frozen_string_literal: true

require "English"
require "set"
require "rubodeputy/dir_walker"
require "rubodeputy/marshaler"

module Rubodeputy
  class Deputy
    include Rubodeputy::DirWalker
    include Rubodeputy::Marshaler

    attr_accessor :dir_to_clean, :progress

    def initialize(dir_to_clean = ".")
      @dir_to_clean = dir_to_clean
      @progress = progress_file? ? unmarshal_progress : empty_progress
    end

    def correct
      correct_subdirs
      correct_root
      marshal_progress
      git_add
    end

    def correct_subdirs
      subdirs.each do |dir|
        lint_and_test(dir)
      end
    end

    def correct_root
      return unless root_dir_files.size.positive?

      file_list = root_dir_files.join(" ")
      autocorrect(file_list)

      unless $CHILD_STATUS.success?
        puts "error running rubocop"
        add_error(dir_to_clean)
        `git checkout #{file_list}`
        return
      end
      add_done(dir_to_clean)
    end

    def reset
      rm_progress_file
      @progress = empty_progress
    end

    def lint_and_test(dir)
      print "#{dir}: "
      if already_progressed_dirs.member?(dir)
        puts "skipping"
        return
      end

      autocorrect(dir)
      unless $CHILD_STATUS.success?
        puts "error running rubocop"
        add_error(dir)
        `git checkout #{dir}`

        return
      end

      # If nothing changed go to next dir
      `git diff --quiet -- #{dir}`
      if $CHILD_STATUS.success?
        puts "nothing to clean"
        add_done(dir)
        return
      end

      test_dir = dir.gsub(/^app/, "test")
      print "testing "
      if Dir.exist?(test_dir)
        print "#{test_dir}..."
        `rails test #{test_dir}`
      else
        print "all..."
        `rails test`
      end

      unless $CHILD_STATUS.success?
        puts "test(s) failed"
        add_failure(dir)

        return
      end

      add_done(dir)
      puts " done!"
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

      def empty_progress
        {
          err_dirs: Set.new,
          failed_dirs: Set.new,
          done_dirs: Set.new,
        }
      end

      def already_progressed_dirs
        progress[:err_dirs] + progress[:failed_dirs] + progress[:done_dirs]
      end

      def autocorrect(dir_or_files)
        `rubocop --autocorrect --fail-level E #{dir_or_files}`
      end

      def git_add
        progress[:done_dirs].each do |dir|
          `git add #{dir}`
        end
      end
  end
end
