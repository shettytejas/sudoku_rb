# frozen_string_literal: true

# Represents a set used in Sudoku puzzles.
class Sudoku::Set
  # @return [Integer] The internal representation of the set.
  attr_reader :set
  # @return [Integer] The number of elements present in the set.
  attr_reader :size

  # The internal representation of an empty set.
  EMPTY_SET = 0
  # The internal representation of a filled set containing all numbers from 1 to 9.
  FILLED_SET = 1022
  # A hash mapping each number in the valid range to its corresponding bit representation.
  SHIFT_MAP = Sudoku::VALID_RANGE.to_h { |i| [i, 1 << i] }

  # Initializes a new Sudoku::Set instance.
  #
  # @param filled [Boolean] Whether to create a filled set or an empty set.
  def initialize(filled: false)
    @set = EMPTY_SET
    @size = 0

    return unless filled

    @set = FILLED_SET
    @size = Sudoku::LENGTH
  end

  # Adds a value to the set.
  #
  # @param value [Integer] The value to be added to the set.
  # @return [Boolean] Returns true if the value was successfully added to the set, false otherwise.
  def push?(value)
    return true if value.zero?
    return false unless in_valid_range?(value) && excludes?(value)

    @set |= SHIFT_MAP[value]
    @size += 1

    true
  end
  alias << push?

  # Removes a value from the set.
  #
  # @param value [Integer] The value to be removed from the set.
  # @return [Boolean] Returns true if the value was successfully removed from the set, false otherwise.
  def pop?(value)
    return true if value.zero?
    return false unless in_valid_range?(value) && includes?(value)

    @set &= ~SHIFT_MAP[value]
    @size -= 1

    true
  end
  alias >> pop?

  # Checks if the set is empty.
  #
  # @return [Boolean] Returns true if the set is empty, false otherwise.
  def empty?
    set.zero?
  end

  # Checks if the set is filled.
  #
  # @return [Boolean] Returns true if the set is filled, false otherwise.
  def filled?
    set.positive?
  end

  # Checks if the set contains a specific value.
  #
  # @param num [Integer] The value to be checked for existence in the set.
  # @return [Boolean] Returns true if the value is present in the set, false otherwise.
  def include?(num)
    return false unless SHIFT_MAP[num]

    (set & SHIFT_MAP[num]).positive?
  end
  alias includes? include?
  alias [] includes?

  # Checks if the set does not contain a specific value.
  #
  # @param num [Integer] The value to be checked for absence in the set.
  # @return [Boolean] Returns true if the value is not present in the set, false otherwise.
  def exclude?(num)
    return true unless SHIFT_MAP[num]

    (set & (1 << num)).zero?
  end
  alias excludes? exclude?

  # Returns an array containing all the numbers present in the set.
  #
  # @return [Array<Integer>] An array containing all the numbers present in the set.
  def all
    return [] if empty?

    Sudoku::VALID_RANGE.select { |i| includes?(i) }
  end

  # Iterates through all the numbers present in the set and performs a block operation on them.
  #
  # @yieldparam value [Integer] The number from the set being processed.
  # @return [Enumerator, nil] If no block is given, returns an enumerator; otherwise, returns nil.
  def each
    return nil if empty?
    return to_enum unless block_given?

    Sudoku::VALID_RANGE.each { |v| yield v if includes?(v) }
  end

  # Compares two sets for equality.
  #
  # @param other [Sudoku::Set] The other set to compare with.
  # @return [Boolean] Returns true if the two sets are equal, false otherwise.
  def ==(other)
    set == other.set
  end
  alias eql? ==

  # Applies bitwise XOR operation with another set (NOT IMPLEMENTED YET).
  #
  # @param _other [Sudoku::Set] The other set to apply the XOR operation with.
  # @raise [RuntimeError] This method is pending implementation.
  def xor!(_other)
    raise 'implementation pending'
  end

  # Returns a string representation of the set.
  #
  # @return [String] A string representation of the set.
  def to_s
    all.to_s
  end

  # Clears the set.
  #
  # @return [TrueClass]
  def clear!
    @set = EMPTY_SET
    @size = 0
    true
  end

  private

  # Checks if the given value is within the valid range (1 to 9).
  #
  # @param value [Integer] The value to be checked.
  # @return [Boolean] Returns true if the value is within the valid range, false otherwise.
  def in_valid_range?(value)
    Sudoku::VALID_RANGE.cover?(value)
  end

  private_constant :EMPTY_SET, :FILLED_SET, :SHIFT_MAP
end
