module Rivendell::Import
  class File

    attr_reader :name, :path

    def initialize(name, attributes = {})
      if attributes[:base_directory]
        @path = name
        @name = relative_filename(name, attributes[:base_directory])
      else
        @name = @path = name
      end
    end

    def relative_filename(path, base_directory)
      ::File.expand_path(path).gsub(%r{^#{::File.expand_path(base_directory)}/},"")
    end

    def to_s
      name
    end

  end
end
