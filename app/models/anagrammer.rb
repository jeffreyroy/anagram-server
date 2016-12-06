require_relative 'word'
require_relative 'trie'
require 'set'

class Anagrammer
  attr_accessor :word_list, :full_text, :max_anagrams
  attr_reader :current_text, :node_hash, :start_node

  def initialize(file_name)
    @max_anagrams = 10
    # Read words from file
    @string_list = read_words_from_file(file_name)
    initialize_word_list
    create_subletter_hash
    puts
    # @subword_list = []
    # create_trie
    puts
    get_text
  end

  # Experimental subword algorithm
  def create_subletter_hash
    puts "Creating subletter hash..."
    count = 0
    @subletter_hash = {}
    # Loop through word list
    @word_list.each do |word|
      count += 1
      print "\r#{count}"
      @subletter_hash[word] = create_subletter_set(word)
    end
  end

  def create_subletter_set(word)
    s = Set.new
    # Loop through letters
    word.letters.each_pair do |letter, occurences|
      # Add subword = letter * occurences
      t = [occurences, 3].min
      s << letter * t if t > 0
    end
    s
  end

  def create_big_subletter_set(word)
    s = Set.new
    # Loop through letters
    word.letters.each_pair do |letter, occurences|
      # Add subword = letter * occurences
      (1..[occurences, 3].min).each do |n|
        s << letter * n
      end
    end
    s
  end

  def create_letter_string_list
    letter_string_list = []
    Word::ALPHABET.each_char do |letter|
      (1..3).each do |n|
        letter_string_list << letter * n
      end
    end
    letter_string_list
  end

  # def create_trie
  #   puts "Generating trie..."
  #   count = 0
  #   alphabet = Word::ALPHABET
  #   # Create root node
  #   @start_node = Node.new("")
  #   @node_hash = { "" => @start_node }
  #   # Loop through all words
  #   @word_list.each do |word|
  #     count += 1
  #     print "\r#{count}"
  #     cur_node = @start_node
  #     new_node = @start_node
  #     cur_string = ""
  #     # Loop through all letters
  #     alphabet.each_char do |letter|
  #       # If word contains this letter
  #       if word.letters[letter] > 0
  #         # Add letter(s) to current string
  #         cur_string = cur_string + letter * word.letters[letter]
  #         # Create new node if necessary
  #         new_node = @node_hash[cur_string]
  #         if !new_node
  #           new_node = Node.new(cur_string)
  #           @node_hash[cur_string] = new_node
  #         end
  #         # Add child if necessary
  #         if !cur_node.children.include?(new_node)
  #           cur_node.children << new_node
  #         end
  #         # Update current node
  #         cur_node = new_node
  #       end
  #     end
  #     cur_node.terminal = true
  #   end
  # end


  # Read list of words from text file
  def read_words_from_file(file_name)
    @file = File.new(file_name)
    puts "Reading file #{file_name}..."
    f = @file.readlines.map { |line| line.chomp }
    puts "#{f.length} lines"
    puts "Sorting..."
    f.sort { |a, b| b.length <=> a.length}
  end

  # Generate list of word objects
  def initialize_word_list
    puts "Generating words..."
    count = 0
    @word_list = @string_list.map do |string| 
      count += 1
      print "\r#{count}"
      Word.new(string)
    end
    puts
  end

  # Get text to anagram
  def get_text
    text = ""
    while text.empty?
      puts "Enter word or short phrase to anagram:"
      text = gets.chomp
    end
    @full_text = Word.new(text)
    reset_text
  end

  # Reset text
  def reset_text
    @current_text = @full_text
    @level = 0
    @current_anagram = ""
  end

  # Display first n elements of list
  def display_first(array, n)
    puts array.first(n)
  end

  # def subwords(text, words)
  #   words.select { |word| text >= word }
  # end

  # This is MUCH more efficient!
  def subwords(text, words)
    s = create_big_subletter_set(text)
    words.select { |word| @subletter_hash[word] <= s }
  end

  # def subwords(text, words)
  #   @subword_list = []
  #   trie_search(text, @start_node)
  #   @subword_list
  # end

  # def trie_search(text, current_node)
  #   # puts "Searching trie..."
  #   # print "/r#{current_node.id}"
  #   if current_node.terminal
  #     @subword_list << current_node.id
  #   end
  #   c = current_node.children
  #   if !c.empty?
  #     c.each do |new_node|
  #       new_letters = new_node.id.delete(current_node.id)
  #       if text.letters[new_letters[0]] >= new_letters.length
  #         trie_search(text, new_node)
  #       end
  #     end
  #   end
  # end


  def anagrams(text, words)
    # Error checking
    if text.empty?
      puts "ERROR - I'm trying to anagram an empty string!"
      return []
    end
    if word_list.empty?
      puts "ERROR - I'm trying to use an empty word list!"
      return []
    end
    # Initialize variables
    anagram_list = []
    current_subwords = subwords(text, words)
    # Show progress
    @level += 1
    # print "." if @level == 2
    # Loop through subwords
    current_subwords.each do |word|
      # Trying to improve speed - 
      # Disallow multiple instances of a word in anagram
      # Remove the current word from the word list
      current_subwords.delete(word)
      new_text = text - word
      if !new_text
        puts "Error subtracting a subword! "
        @level -= 1
        return []
      end
      # If there is still text remaining and we haven't reached the last subword,
      # anagram the remaining text
      if new_text.length > 0 
        if !current_subwords.empty?
          a = anagrams(new_text, current_subwords)
          if a.length > 0
            a.each do |cur_anagram|
              new_anagram = word + " " + cur_anagram
              anagram_list << new_anagram
              puts new_anagram if @level == 1
              if anagram_list.length > @max_anagrams
                @level -= 1
                return anagram_list 
              end
            end
          end
        end
      # Otherwise, add the word itself as an anagram
      else
        anagram_list << word
      end
    end
    # Return list of anagrams
    @level -= 1
    anagram_list
  end

  # Move word to top of word list, adding it if not already there
  def prefer(string)
    word = add(string)
    @word_list.insert(0, word)
  end

  # Move word to bottom of word list
  def unprefer(string)
    word = add(string)
    @word_list.push(word)
  end

  # Prepare to add string to word list
  def add(string)
    word = Word.new(string)
    remove(word)
    @subletter_hash[word] = create_subletter_set(word)
    word
  end

  # Remove word from word list
  def remove(word)
    if (@word_list.include?(word))
      @word_list.delete(word)
    end
  end

  def get_word
    done = false
    while !done
      print "Enter a subword: "
      string = gets.chomp
      word = Word.new(string)
      # Check to see whether user is entering a command
      if(string[0] == "$")
        execute_command(string.delete("$"))
        return nil
      elsif !(@current_text >= word)
        puts "That's not a subword. "
      elsif !@word_list.include?(word)
        puts "That's not on the list."
        puts "Would you like to add it? (y/n)"
        answer = gets.chomp.downcase[0]
        if answer == "y"
          prefer(string)
          done = true
        end
      else 
        prefer(string)
        done = true
      end
    end
    word
  end

  def execute_command(string)
    case string
    when "reset"
      reset_text
    when "subwords"
      s = subwords(@current_text, @word_list)
      puts "Best subwords: "
      display_first(s, 10)
    when "anagrams"
      s = anagrams(@current_text, @word_list)
      # puts "Best anagrams: "
      # display_first(s, 10)
    when "words"
      display_first(@word_list, 10)
    end
  end

  def main_loop
    while !@current_text.empty?
      puts
      puts "Current anagram: #{@current_anagram}"
      puts "Remaining text: #{@current_text}"
      word = get_word
      if word
        @current_text -= word
        @current_anagram += " " + word
      end
    end
  end

  # Helper method to test speed of subword generation
  def subword_timer(reps=10)
    time = Time.now
    reps.times do
      subwords(@current_text, @word_list)
    end
    Time.now - time
  end

end

# a = Anagrammer.new("small.txt")
a = Anagrammer.new("twl06.txt")
puts a.current_text.a
# a.prefer("old")
# a.unprefer("pauldron")
# a.prefer("normal")

# while true
#   puts "Enter search string: "
#   string = gets.chomp
#   n = a.node_hash[string]
#   if !n
#     puts "Not found."
#   else
#     p n.id
#     p n.terminal ? "Terminal" : "Not terminal"
#     c = n.children
#     if c.empty?
#       puts "No children."
#     else
#       p c.map { |node| node.id }
#     end
#   end
# end

# s = a.subwords(a.current_text, a.word_list)
s = a.anagrams(a.current_text, a.word_list)

# p a.subword_timer
a.main_loop