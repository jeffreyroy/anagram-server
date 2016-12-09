class AnagramsController < ApplicationController

  def index
    puts "Getting word list..."
    @word_list = Rails.application.config.anagrammer.word_list
    puts "Generating blurb..."
    @blurb = @word_list[rand(10)]
  end

  def new
  end

  def create
    @anagram_text = params[:text]
    redirect_to action: 'show', text: @anagram_text
  end

  def show
    puts "Getting text to anagram:"
    @text = Word.new(params[:text])
    puts @text
    a = Rails.application.config.anagrammer
    puts "Word list begins with #{a.word_list[0]}"
    puts "Generating anagrams..."
    @subwords = a.subwords(@text, a.word_list)
    @anagrams = a.anagrams(@text, a.word_list)

  end

end
