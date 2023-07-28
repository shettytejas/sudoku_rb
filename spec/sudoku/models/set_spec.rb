# frozen_string_literal: true

require 'sudoku/models/set'

RSpec.describe Sudoku::Set do
  let(:empty_set) { Sudoku::Set.new }
  let(:filled_set) { Sudoku::Set.new(filled: true) }

  describe 'initialization' do
    subject(:result) { described_class.new(filled: filled) }

    context 'with an empty set' do
      let(:filled) { false }

      it 'creates an empty set' do
        expect(result).to be_a described_class
        expect(result).not_to be_filled
        expect(result.size).to be_zero
        expect(result.all).to eq([])
      end
    end

    context 'with a filled set' do
      let(:filled) { true }

      it 'creates a filled set with all numbers' do
        expect(result).not_to be_empty
        expect(result).to be_filled
        expect(result.size).to eq(Sudoku::LENGTH)
        expect(result.all).to eq(Sudoku::VALID_RANGE.to_a)
      end
    end
  end

  describe '#push?' do
    subject(:result) { ->(val) { set.push?(val) } }

    let(:set) { described_class.new }

    it 'adds a value to the set' do
      expect(result.call(3)).to be true
      expect(result.call(3)).to be false # Value already exists
      expect(result.call(0)).to be true # 0 can never be added/removed
      expect(result.call(10)).to be false # Value out of valid range
      expect(result.call(2)).to be true
      expect(result.call(5)).to be true
      expect(result.call(7)).to be true
      expect(result.call(9)).to be true
      expect(set.all).to eq([2, 3, 5, 7, 9])
    end
  end

  describe '#<<' do
    subject(:result) { ->(val) { set << val } }

    let(:set) { described_class.new }

    it 'adds a value to the set' do
      expect(result.call(3)).to be true
      expect(result.call(3)).to be false # Value already exists
      expect(result.call(0)).to be true # 0 can never be added/removed
      expect(result.call(10)).to be false # Value out of valid range
      expect(result.call(2)).to be true
      expect(result.call(5)).to be true
      expect(result.call(7)).to be true
      expect(result.call(9)).to be true
      expect(set.all).to eq([2, 3, 5, 7, 9])
    end
  end

  describe '#pop?' do
    subject(:result) { ->(val) { set.pop?(val) } }

    let(:set) { described_class.new(filled: true) }

    it 'removes a value from the set' do
      expect(result.call(3)).to be true
      expect(result.call(3)).to be false # Value doesn't exist anymore
      expect(result.call(0)).to be true # 0 can never be added/removed
      expect(result.call(10)).to be false # Value out of valid range
      expect(result.call(2)).to be true
      expect(result.call(5)).to be true
      expect(result.call(7)).to be true
      expect(result.call(9)).to be true
      expect(set.all).to eq([1, 4, 6, 8])
    end
  end

  describe '#>>' do
    subject(:result) { ->(val) { set >> val } }

    let(:set) { described_class.new(filled: true) }

    it 'removes a value from the set' do
      expect(result.call(3)).to be true
      expect(result.call(3)).to be false # Value doesn't exist anymore
      expect(result.call(0)).to be true # 0 can never be added/removed
      expect(result.call(10)).to be false # Value out of valid range
      expect(result.call(2)).to be true
      expect(result.call(5)).to be true
      expect(result.call(7)).to be true
      expect(result.call(9)).to be true
      expect(set.all).to eq([1, 4, 6, 8])
    end
  end

  describe '#empty?' do
    let(:empty_set) { Sudoku::Set.new }
    let(:partially_filled_set) { Sudoku::Set.new }
    let(:filled_set) { Sudoku::Set.new(filled: true) }

    before do
      partially_filled_set.push? 3
    end

    it 'returns true if the set is empty' do
      expect(empty_set.size).to be_zero
      expect(empty_set).to be_empty
      expect(partially_filled_set.size).not_to be_zero
      expect(partially_filled_set).not_to be_empty
      expect(filled_set.size).not_to be_zero
      expect(filled_set).not_to be_empty
    end
  end

  describe '#filled?' do
    let(:empty_set) { Sudoku::Set.new }
    let(:partially_filled_set) { Sudoku::Set.new }
    let(:filled_set) { Sudoku::Set.new(filled: true) }

    before do
      partially_filled_set.push? 3
    end

    it 'returns true if the set is empty' do
      expect(empty_set.size).to be_zero
      expect(empty_set).not_to be_filled
      expect(partially_filled_set.size).not_to be_zero
      expect(partially_filled_set).to be_filled
      expect(filled_set.size).not_to be_zero
      expect(filled_set).to be_filled
    end
  end

  describe '#include?' do
    let(:empty_set) { Sudoku::Set.new }
    let(:filled_set) { Sudoku::Set.new(filled: true) }

    it 'returns true if the set contains a value' do
      expect(empty_set).not_to include(3)
      expect(empty_set).not_to include(0)
      expect(filled_set).to include(3)
      expect(filled_set).not_to include(0)
      expect(filled_set).not_to include(10)
    end
  end

  describe '#exclude?' do
    let(:empty_set) { Sudoku::Set.new }
    let(:filled_set) { Sudoku::Set.new(filled: true) }

    it 'returns true if the set does not contain a value' do
      expect(empty_set).to exclude(3)
      expect(empty_set).to exclude(0)
      expect(filled_set).not_to exclude(3)
      expect(filled_set).to exclude(0)
      expect(filled_set).to exclude(10)
    end
  end

  describe '#all' do
    let(:empty_set) { Sudoku::Set.new }
    let(:partially_filled_set) { Sudoku::Set.new }
    let(:filled_set) { Sudoku::Set.new(filled: true) }

    before do
      partially_filled_set.push? 3
      partially_filled_set.push? 6
      partially_filled_set.push? 9
    end

    it 'returns all numbers present in the set' do
      expect(empty_set.all).to eq([])
      expect(partially_filled_set.all).to eq([3, 6, 9])
      expect(filled_set.all).to eq(Sudoku::VALID_RANGE.to_a)
    end
  end

  describe '#each' do
    let(:empty_set) { Sudoku::Set.new }
    let(:partially_filled_set) { Sudoku::Set.new }
    let(:filled_set) { Sudoku::Set.new(filled: true) }

    before do
      partially_filled_set.push? 3
      partially_filled_set.push? 6
      partially_filled_set.push? 9
    end

    it 'iterates through all the numbers present in the set' do
      nums = []
      empty_set.each { |num| nums << num }
      expect(nums).to eq([])

      nums = []
      partially_filled_set.each { |num| nums << num }
      expect(nums).to eq([3, 6, 9])

      nums = []
      filled_set.each { |num| nums << num }
      expect(nums).to eq(Sudoku::VALID_RANGE.to_a)
    end
  end

  describe '#==' do
    let(:empty_set) { Sudoku::Set.new }
    let(:partially_filled_set) { Sudoku::Set.new }
    let(:filled_set) { Sudoku::Set.new(filled: true) }

    before do
      partially_filled_set.push? 3
      partially_filled_set.push? 6
      partially_filled_set.push? 9
    end

    it 'returns true if two sets are equal' do
      set = Sudoku::Set.new

      expect(empty_set == set).to be true
      expect(partially_filled_set == set).to be false
      expect(filled_set == set).to be false
    end
  end

  describe '#to_s' do
    let(:empty_set) { Sudoku::Set.new }
    let(:partially_filled_set) { Sudoku::Set.new }
    let(:filled_set) { Sudoku::Set.new(filled: true) }

    before do
      partially_filled_set.push? 3
      partially_filled_set.push? 6
      partially_filled_set.push? 9
    end

    it 'returns a string representation of the set' do
      expect(empty_set.to_s).to eq('[]')
      expect(partially_filled_set.to_s).to eq('[3, 6, 9]')
      expect(filled_set.to_s).to eq('[1, 2, 3, 4, 5, 6, 7, 8, 9]')
    end
  end

  describe '#clear!' do
    let(:empty_set) { Sudoku::Set.new }
    let(:partially_filled_set) { Sudoku::Set.new }
    let(:filled_set) { Sudoku::Set.new(filled: true) }

    before do
      partially_filled_set.push? 3
      partially_filled_set.push? 6
      partially_filled_set.push? 9
    end

    it 'clears the set' do
      expect(empty_set.size).to be_zero
      expect(empty_set.clear!).to be true
      expect(empty_set.size).to be_zero

      expect(partially_filled_set.size).not_to be_zero
      expect(partially_filled_set.clear!).to be true
      expect(partially_filled_set.size).to be_zero

      expect(filled_set.size).not_to be_zero
      expect(filled_set.clear!).to be true
      expect(filled_set.size).to be_zero
    end
  end

  describe 'edge cases' do
    it 'handles edge cases' do
      set = Sudoku::Set.new
      expect(set.includes?(0)).to be false
      expect(set.includes?(10)).to be false
      expect(set.excludes?(0)).to be true
      expect(set.excludes?(10)).to be true
      expect(set.pop?(0)).to be true
      expect(set.push?(0)).to be true
      expect(set.empty?).to be true
      expect(set.filled?).to be false
      expect(set.push?(3)).to be true
      expect(set.push?(6)).to be true
      expect(set.pop?(0)).to be true
      expect(set.filled?).to be true
      expect(set.size).to eq(2)
      expect(set.all).to eq([3, 6])
      expect(set.each.to_a).to eq([3, 6])
    end
  end
end
