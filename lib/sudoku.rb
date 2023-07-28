# frozen_string_literal: true

module Sudoku
  LENGTH = 9
  CELL_COUNT = LENGTH**2
  GRID_LENGTH = Math.sqrt(LENGTH).round
  VALID_RANGE = (1..LENGTH)

  VERSION = '0.1.0'

  class StringNotValidException < StandardError
    def initialize
      super("Given sudoku string is not valid. It should be of length #{GRID_LENGTH} and should contain only digits with '0' and '.' for unknown cells")
    end
  end

  class InvalidBoard < StandardError
    def initialize
      super('Given sudoku string is not valid. It has duplicated numbers')
    end
  end
end
