# frozen_string_literal: true
require 'pp'

# INPUT_FILE = "sampleinput.txt"
INPUT_FILE = "input.txt"

# EXPANSION=1 # Part 1
# Minus one because the one row already exists
# EXPANSION=10-1 # Part 2 Example 1
# EXPANSION=100-1 # Part 2 Example 2
EXPANSION=1000000-1 # Part 2 Real

def load_file
  file_data = Array.new
  current_array = Array.new
  File.read(INPUT_FILE).bytes.each do |byte|
    if byte == "\n".ord
      file_data.append(current_array)
      current_array = Array.new
    else
      current_array.append(byte)
    end
  end
  file_data
end

def expand_space(space)
  raise 'Illegal argument' unless space.kind_of?(Array)
  empty_rows = space.each_index.filter { |y|
    !space[0].each_index.any? { |x|
      space[y][x] != '.'.ord
    }
  }
  empty_columns = space[0].each_index.filter { |x|
    !space.each_index.any? { |y|
      space[y][x] != '.'.ord
    }
  }
  [empty_rows, empty_columns]

  # empty_rows.reverse.each do |y|
  #   space.insert(y, Array.new(space[0].length, '.'.ord))
  # end
  # empty_columns.reverse.each do |x|
  #   space.each_index do |y|
  #     space[y].insert(x, '.'.ord)
  #   end
  # end
end

def find_stars(space)
  raise 'Illegal argument' unless space.kind_of?(Array)
  stars = Array.new
  space.each_index do |y|
    space[0].each_index do |x|
      if space[y][x] == '#'.ord
        stars.append([x, y])
      end
    end
  end
  stars
end

def expand_stars(stars, empty_rows, empty_columns)
  raise 'Illegal argument' unless stars.kind_of?(Array)
  raise 'Illegal argument' unless empty_rows.kind_of?(Array)
  raise 'Illegal argument' unless empty_columns.kind_of?(Array)
  stars.each do |star|
    raise 'Illegal argument' unless star.kind_of?(Array)
    extra_rows = empty_rows.count { |x| star[1] > x }
    extra_columns = empty_columns.count { |y| star[0] > y }
    star[0] = star[0] + extra_columns * EXPANSION
    star[1] = star[1] + extra_rows * EXPANSION
    # pp star
  end
  # code here
end

def distance_stars(a, b)
  ((a[0] - b[0]).abs) + ((a[1] - b[1]).abs)
end

space = load_file
(empty_rows, empty_columns) = expand_space(space)
stars = find_stars(space)
expand_stars(stars, empty_rows, empty_columns)

total_distance = 0

stars.combination(2) do |a, b|
  # idx1 = stars.find_index a
  # idx2 = stars.find_index b
  distance = distance_stars a, b
  # pp [idx1, idx2, a, b, distance]
  total_distance += distance
end

pp total_distance