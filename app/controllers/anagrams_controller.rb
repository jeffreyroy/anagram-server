class AnagramsController < ApplicationController

  def index
    puts "Getting word list..."
    @word_list = Rails.application.config.anagrammer.word_list
    puts "Generating blurb..."
    @blurb = @word_list[rand(10)]
  end

end
