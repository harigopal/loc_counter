require 'spec_helper'

describe LOCCounter::Project do
  before(:each) do
    stub_files
    @dir_path = '/path/to/project'
  end

  describe '#initialize' do
    context 'with a non-existent directory' do
      it 'raises an ArgumentError' do
        expect {
          LOCCounter::Project.new('foo')
        }.to raise_error(ArgumentError)
      end
    end

    context 'with an existing directory' do
      before(:each) do
        allow(File).to receive(:exists?).and_return(true)
        allow(Dir).to receive(:glob).and_return(@filenames)
      end

      it 'puts the files list from Dir.glob to @files' do
        expect(Dir).to receive(:glob).with(@dir_path + '/' + LOCCounter::Project::SOURCE_FILES.first)
        project = LOCCounter::Project.new(@dir_path)
        expect(project.files).to eq([@file1, @file2] * LOCCounter::Project::SOURCE_FILES.count)
      end
    end
  end
end
