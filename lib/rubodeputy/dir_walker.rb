module Rubodeputy
  module DirWalker
    def subdirs
      @subdirs ||= Dir["#{dir_to_clean}/**/*"]
        .filter { |dir| File.directory?(dir) }
        .push(dir_to_clean)
        .sort { |dir1, dir2| dir2.count("/") <=> dir1.count("/") }
        .uniq
    end

    def files_for_dir(dir)
      Dir["#{dir}/*"].filter { |f| File.file?(f) }
    end
  end
end
