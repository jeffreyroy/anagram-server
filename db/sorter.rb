

@word_list = []

def read_words_from_file(file_name)
  file_location = file_name
  @file = File.new(file_location)
  puts "Reading file #{file_name}..."
  @word_list = @file.readlines.map { |line| line.chomp }
  # @word_list = CSV.parse(@file, :headers => false)
  puts "#{@word_list.length} lines"
end

def sort_word_list
  puts "Sorting..."
  @word_list.sort! { |a, b| b.length <=> a.length}
end

def write_words_to_file(file_name)
  file_location = file_name
  @file = File.new(file_location, "w")
  puts "Writing to file #{file_name}..."
  @word_list.each { |line| @file.puts line }
  # @word_list = CSV.parse(@file, :headers => false)

end

read_words_from_file("english-usa.txt")
sort_word_list
write_words_to_file("sorted-common.txt")