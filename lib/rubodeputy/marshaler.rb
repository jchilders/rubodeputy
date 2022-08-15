require "fileutils"
require "forwardable"

module Rubodeputy
  module Marshaler
    extend Forwardable

    PROGRESS_FILE = "rubodeputy_progress"

    class << self
      def included(mod)
        mod.extend self
      end
    end

    def progress_file
      if File.directory?("tmp")
        FileUtils.mkdir_p "./tmp/rubodeputy"
        "tmp/rubodeputy/#{PROGRESS_FILE}"
      else
        PROGRESS_FILE
      end
    end

    def print_stats(options = {})
      puts "Num dirs with Rubocop errors: #{progress[:err_dirs].size}"
      puts progress[:err_dirs].join(", ") if options["verbose"]
      puts "Num dirs with test failures: #{progress[:failed_dirs].size}"
      puts progress[:failed_dirs].join(", ") if options["verbose"]
      puts "Num completed dirs: #{progress[:done_dirs].size}"
      puts progress[:done_dirs].join(", ") if options["verbose"]
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
      progress_file? ? Marshal.load(File.read(progress_file)) : {}
    end
  end
end
