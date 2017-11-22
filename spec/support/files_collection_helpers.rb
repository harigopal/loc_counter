module FilesCollectionHelpers
  # setting filenames, files and LOCCounter::SourceFile.new
  def stub_files
    @filename1 = double('First file name')
    @filename2 = double('Second file name')
    @filenames = [@filename1, @filename2]

    @file1 = double('LOCCounter::SourceFile instance for filename1')
    @file2 = double('LOCCounter::SourceFile instance for filename2')
    @files = [@file1, @file2]

    allow(LOCCounter::SourceFile).to receive(:new) do |filename|
      case filename
        when @filename1 then
          @file1
        when @filename2 then
          @file2
        else
          raise "Unexpected filename: #{filename}"
      end
    end
  end
end
