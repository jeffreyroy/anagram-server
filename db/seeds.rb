# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# require 'csv'

@word_list = []

def clear_table
  Vocab.delete_all
  Subject.delete_all
  Anagram.delete_all
end

def read_words_from_file(file_name)
  file_location = Rails.root.join('db', file_name)
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

def initialize_word_list
  puts "Generating words..."
  count = 0
  @word_list.each do |string| 
    count += 1
    print "\r#{count}"
    Vocab.create( word_string: string )
  end
  puts
end

clear_table
read_words_from_file("wiki-filtered.txt")
sort_word_list
initialize_word_list

s = Subject.create(subject_text: "George Bush")
a = Anagram.new(anagram_text: "He bugs Gore")
s.anagrams << a
a.save

