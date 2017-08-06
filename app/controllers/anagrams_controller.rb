class AnagramsController < ApplicationController

  def index
    @subject_list = Subject.all
    puts "Subject list: "
    p @subject_list
  end

  def new
  end

  def create
    @anagram_text = params[:text]
    redirect_to action: 'show', text: @anagram_text
  end

  def save
    print "Params: "
    p params
    a = Rails.application.config.anagrammer
    subject_text = Word.new(params[:subject])
    anagram_text = a.current_anagram.dup
    anagram = Anagram.new({ anagram_text: anagram_text }) 
    puts "Saving #{anagram} for subject #{subject_text}..."
    # locate subject, if it exists
    subject_list = Subject.all
    alphabetized_list = subject_list.map { |subject| subject.alphabetized }
    i = alphabetized_list.index(subject_text.a)
    if i
      @subject = subject_list[i]
    else
      # if not, create a new subject
      @subject = Subject.create(subject_text: subject_text)
    end
    @subject.anagrams << anagram
    # save anagram
    anagram.save
  end

  def show
    puts "Getting text to anagram:"
    @text = Word.new(params[:text])
    puts @text
    a = Rails.application.config.anagrammer
    a.set_text(@text)
    @current = a.current_anagram
    @current_words = @current.split
    puts "Word list begins with #{a.word_list[0]}"
    puts "Generating anagrams..."
    @subwords = a.current_subwords
    if @text.length > 25
      @anagrams = ["(Text too long to anagram; add words)"]
    else
      @anagrams = a.current_anagrams
    end
  end

end
