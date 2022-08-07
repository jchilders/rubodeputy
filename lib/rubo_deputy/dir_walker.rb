module RuboDeputy
  module DirWalker
    def subdirs
      @subdirs ||= Dir["#{dir_to_clean}/**/*"].filter { |dir| File.directory?(dir) }
    end
  end
end
