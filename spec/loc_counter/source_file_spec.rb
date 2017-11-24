require_relative '../spec_helper'

describe LOCCounter::SourceFile do
  before(:each) do
    path = File.expand_path('../../fixtures/test.rb', __FILE__)
    @file = LOCCounter::SourceFile.new(path)
  end

  describe '#initialize' do
    before(:each) do
      @filename = double('Filename')
      @lines = double('Source lines')
      allow(File).to receive(:readlines).and_return(@lines)
    end

    context 'with a non-existent file' do
      it 'raises an ArgumentError' do
        expect {
          LOCCounter::SourceFile.new('foo')
        }.to raise_error(ArgumentError)
      end
    end

    context 'with an existing file' do
      before(:each) do
        allow(File).to receive(:exists?).and_return(true)
      end

      it 'puts the result of File.readlines to @lines' do
        expect(File).to receive(:readlines).with(@filename)
        file = LOCCounter::SourceFile.new(@filename)
        expect(file.lines).to eq(@lines)
      end
    end
  end

  describe '#counts' do
    before(:each) do
      @counts = @file.counts
      @lines  = @file.lines
    end

    describe '[:total]' do
      it 'returns total lines count' do
        expect(@counts[:total]).to eq(@lines.count)
      end
    end

    describe '[:empty]' do
      it 'returns a number of empty lines' do
        empty_lines = @lines.find_all do |line|
          line =~ LOCCounter::SourceFile::EMPTY_PATTERN
        end

        expect(@counts[:empty]).to eq(empty_lines.count)
      end
    end

    describe '[:comments]' do
      it 'returns a number of lines containing just a comment' do
        comments_lines = @lines.find_all do |line|
          line =~ LOCCounter::SourceFile::COMMENT_PATTERN
        end

        expect(@counts[:comments]).to eq(comments_lines.count)
      end
    end

    describe '[:code]' do
      it 'returns a number of lines containing any code' do
        code_lines = @lines.reject do |line|
          line =~ LOCCounter::SourceFile::EMPTY_PATTERN || line =~ LOCCounter::SourceFile::COMMENT_PATTERN
        end

        expect(@counts[:code]).to eq(code_lines.count)
      end
    end
  end
end
