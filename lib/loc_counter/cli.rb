# Gems
require 'active_support/inflector'
require 'terminal-table'

# Local
require_relative 'project'
require_relative 'files_collection'

module LOCCounter
  class CLI
    include Commander::Methods

    def run
      program :name, 'loc_counter'
      program :version, '0.1'
      program :description, 'Scans a project or individual files for source files and outputs LOC counts.'

      command :count do |c|
        c.syntax = 'loc_counter count [options]'
        c.summary = 'Counts LOC in supplied paths'
        c.description = 'loc_counter can be asked to scan more than one location - folders or files.'
        c.example 'Outputs LOC stats for a file', 'loc_counter count /path/to/file'
        c.example 'Outputs LOC stats for all files in a folder', 'loc_counter count /path/to/project'
        c.example 'Outputs LOC stats for multiple paths', 'loc_counter count /path/to/a/folder /path/to/another/folder'
        c.option '--format', 'Select output format. Defaults to "text", can also be "json".'

        c.action do |args, _options|
          if args.empty?
            # no arguments received
            say 'No path was given'
          elsif args.count == 1 && File.directory?(args.first)
            # received one argument which is a directory path
            say table(LOCCounter::Project.new(args.first).counts)
          else
            # received one or more paths
            say table(LOCCounter::FilesCollection.new(args).counts)
          end
        end
      end

      run!
    end

    private

    def table(counts)
      # '46 files processed'
      say pluralized_noun(counts.delete(:files), 'file') + ' processed'

      counts.each_with_object(Terminal::Table.new) do |(type, count), table|
        type = type.to_s.capitalize
        count = pluralized_noun(count, 'line')
        table.add_row [type, count]
      end
    end

    # pluralized_noun(53, 'octopus') # => '53 octopi'
    def pluralized_noun(number, noun)
      "#{number} #{noun.pluralize(number)}"
    end
  end
end
