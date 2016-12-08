
# Class representing anagrammable words
class Word < String
  attr_reader :a, :set, :letters

  ALPHABET = "abcdefghijklmnopqrstuvwxyz"

  def initialize(string)
    super(string)
    # Include alphabetized string as an object variable
    @a = sort
    # Letters represented as a hash { letter => number of occurences}
    @letters = letter_hash
  end

  # Remove non-letter characters
  def simplify
    String.new(downcase.gsub(/[^a-z]/i, ''))
  end

  # Return array of characters
  def chars
    simplify.split("")
  end

  # Return string sorted into alphabetical order
  def sort
    chars.sort.join
  end

  # Return hash containing count of each letter
  def letter_hash
    new_hash = {}
    self.class::ALPHABET.each_char do |char|
      new_hash[char] = a.count(char)
    end
    new_hash
  end

  # Remove letters of subword from string
  # Return nil if not a subword
  def subtract_letters(word)
    new_hash = {}
    @letters.each_key do |key|
      new_hash[key] = @letters[key] - word.letters[key]
      return nil if new_hash[key] < 0
    end
    return new_hash
  end

  # Class method to construct word from a letter hash
  def self.construct_word(letter_hash)
    new_string = ""
    letter_hash.each_pair do |key, value|
      new_string << key * value
    end
    Word.new(new_string)
  end

  # Remove letters of subword from string
  # Return nil if not a subword
  def -(subword)
    # Quick check to see if includes the same letters
    letters = subtract_letters(Word.new(subword))
    return nil if letters == nil
    Word.construct_word(letters)
  end


  # Subwords
  def ==(word)
    a == word.a
  end

  def !=(word)
    a != word.a
  end

  def >=(word)
    !!(self - word)
  end

  def <=(word)
    !!(word - self)
  end

  def >(word)
    self >= word && self != word
  end

  def <(word)
    self <= word && self != word
  end

  def test
    word = Word.new("wjfksjdngl")
    new_hash = {}
    letters.each_key do |key|
      new_hash[key] = letters[key] - word.letters[key]
      return nil if new_hash[key] < 0
    end
    return new_hash
  end

  # Helper method to test speed
  def timer(method_name, reps=100000)
    time = Time.now
    reps.times do
      send(method_name)
    end
    Time.now - time
  end


end

# Driver code

# a = Word.new("orchestra")
# p a.a
# p a.set
# b = Word.new("horse")
# p b.a
# p b.set
# p a > b
# p a < b
# c = Word.new("This, has-punctuation!!1!1")
# p c.a
# puts
# p a.letters
# p c.letters

# w = a - b
# p w.a
# p a > b
# p b > a

# p a.timer(:test)



