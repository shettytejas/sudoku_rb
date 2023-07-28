# frozen_string_literal: true

RSpec.describe Sudoku do
  it 'has a version number' do
    expect(Sudoku::VERSION).not_to be nil
  end

  it 'has a length constant of 9' do
    expect(Sudoku::LENGTH).to eq(9)
  end

  it 'has a valid range constant of (1..9)' do
    expect(Sudoku::VALID_RANGE).to eq((1..9))
  end
end
