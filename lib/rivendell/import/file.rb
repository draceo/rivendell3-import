module Rivendell::Import
  class File

    attr_reader :name, :path

    def initialize(name, attributes = {})
      if attributes[:base_directory]
        @path = name
        @name = self.class.relative_filename(name, attributes[:base_directory])
      elsif attributes[:path]
        @name = name
        @path = attributes[:path]
      else
        @name = @path = name
      end
    end

    def self.relative_filename(path, base_directory)
      ::File.expand_path(path).gsub(%r{^#{::File.expand_path(base_directory)}/},"")
    end

    def to_s
      name
    end

    def basename
      ::File.basename(name, ".#{extension}")
    end

    def extension
      ::File.extname(name).gsub(/^\./,'')
    end

    def ==(other)
      other and path == other.path
    end

    def match(expression)
      name.match(expression).tap do |result|
        verb = result ? "match" : "doesn't match"
        Rivendell::Import.logger.debug "File #{verb} '#{expression}'"
        !!result
      end
    end

    def modification_age
      Time.now - ::File.mtime(path) if exists?
    end

    def in(directory, &block)
      if match %r{^#{directory}/}
        yield
      end
    end

    def exists?
      ::File.exists? path
    end

    def destroy!
      Rivendell::Import.logger.debug "Delete file #{path}"
      ::File.delete(path) if exists?
    end

  end
end
