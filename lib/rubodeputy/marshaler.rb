require "fileutils"

module Rubodeputy
  module Marshaler
    extend self

    PROGRESS_FILE = "rubodeputy_progress"

    def progress_file
      if File.directory?("tmp")
        FileUtils.mkdir_p "./tmp/rubodeputy"
        "tmp/rubodeputy/#{PROGRESS_FILE}"
      else
        PROGRESS_FILE
      end
    end

    def progress_file?
      File.exist?(progress_file)
    end

    def rm_progress_file
      FileUtils.rm_f progress_file
    end

    def marshal_progress
      File.write(progress_file, Marshal.dump(progress))
    end

    def unmarshal_progress
      progress_file? ? Marshal.load(File.read(progress_file)) : empty_progress
    end

    def progress
      @progress ||= unmarshal_progress
    end

    def reset
      rm_progress_file
      @progress = empty_progress
    end

    private

      def empty_progress
        {
          corrected_dirs: Set.new,
          tested_dirs: Set.new,
          err_dirs: Set.new,
          tests_failed_dirs: Set.new,
          done_dirs: Set.new,
        }
      end

      trap "SIGINT" do
        marshal_progress
        exit(0)
      end
  end
end
