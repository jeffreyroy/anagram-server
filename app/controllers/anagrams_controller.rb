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
    a.set_text(@text)
    @current = a.current_anagram
    puts "Word list begins with #{a.word_list[0]}"
    puts "Generating anagrams..."
    @subwords = a.current_subwords
    @anagrams = a.current_anagrams
  end

  def subword
    subword = params[:subword]
    puts "Adding subword #{subword}"
    a = Rails.application.config.anagrammer
    @response = a.server_response(subword)
    status = @response[:status]
    respond_to do |format|
      if status != "fail"
        # It's a subword
        format.html do
          redirect_to "/anagrams/#{a.current_text}"
        end
        format.json { render json: @response, status: :ok}
      else
        format.html do
          redirect_to "/anagrams/#{a.current_text}"
        end
        # It's not a subword
        format.json { render json: @response, status: :unprocessable_entity }
      end
    end
  end

end
