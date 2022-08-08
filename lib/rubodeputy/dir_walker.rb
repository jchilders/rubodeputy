module Rubodeputy
  module DirWalker
    def subdirs
      @subdirs ||= Dir["#{dir_to_clean}/**/*"].filter { |dir| File.directory?(dir) }
    end

    def root_dir_files
      Dir["#{dir_to_clean}/*"].filter { |f| File.file?(f) }
    end
  end
end
