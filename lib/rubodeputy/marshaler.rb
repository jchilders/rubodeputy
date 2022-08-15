require "fileutils"

module Rubodeputy
  module Marshaler
    extend self

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
