class AnagramsController < ApplicationController

  def index
    puts "Getting word list..."
    @word_list = Rails.application.config.anagrammer.word_list
    puts "Generating blurb..."
    @blurb = @word_list[rand(10)]
  end

  def show
    puts "Getting text to anagram:"
    @text = Word.new(params[:word])
    puts @text
    a = Rails.application.config.anagrammer
    puts "Word list begins with #{a.word_list[0]}"
    puts "Generating anagrams..."
    @anagrams = a.anagrams(@text, a.word_list)

  end

end
