module Rubodeputy
  module DirWalker
    def subdirs
      @subdirs ||= Dir["#{dir_to_clean}/**/*"]
        .filter { |dir| File.directory?(dir) }
        .sort { |dir1, dir2| dir2.count("/") <=> dir1.count("/") }
    end

    def root_dir_files
      Dir["#{dir_to_clean}/*"].filter { |f| File.file?(f) }
    end
  end
end
