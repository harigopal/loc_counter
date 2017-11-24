require_relative '../spec_helper'

describe LOCCounter::FilesCollection do
  before(:each) do
    stub_files
    allow(File).to receive(:exists?).and_return(true)
  end

  describe '#initialize' do
    before(:each) do
      allow(@filename1).to receive(:=~).and_return(true)
      allow(@filename2).to receive(:=~).and_return(false)
    end

    it 'puts the filtered files list to @files' do
      collection = LOCCounter::FilesCollection.new(@filenames)
      expect(collection.files).to eq([@file1])
    end
  end

  describe '#counts' do
    before(:each) do
      @file1_counts = {
        :total    => 5,
        :empty    => 0,
        :comments => 1,
        :code     => 4
      }

      allow(@file1).to receive(:counts).and_return(@file1_counts)

      @file2_counts = {
        :total    => 8,
        :empty    => 1,
        :comments => 2,
        :code     => 5
      }

      allow(@file2).to receive(:counts).and_return(@file2_counts)
    end

    it 'sums line counts from all files and returns them in a hash' do
      collection = LOCCounter::FilesCollection.new(@filenames)
      collection.instance_variable_set(:@files, @files)
      counts = collection.counts

      expect(counts[:total]).to eq(@file1_counts[:total] + @file2_counts[:total])
      expect(counts[:empty]).to eq(@file1_counts[:empty] + @file2_counts[:empty])
      expect(counts[:comments]).to eq(@file1_counts[:comments] + @file2_counts[:comments])
      expect(counts[:code]).to eq(@file1_counts[:code] + @file2_counts[:code])
      expect(counts[:files]).to eq(@files.count)
    end
  end
end
