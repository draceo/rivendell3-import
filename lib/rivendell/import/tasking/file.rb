module Rivendell::Import::Tasking
  module File
    def file=(file)
      if file
        @file = file

        self.file_name = file.name
        self.file_path = file.path
      else
        @file = nil

        self.file_name = self.file_path = nil
      end
    end

    def file
      @file ||= Rivendell::Import::File.new(file_name, :path => file_path)
    end
  end
end
