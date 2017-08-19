class AnagramsController < ApplicationController

  def index
    @subject_list = Subject.all
    puts "Subject list: "
    p @subject_list
  end

  def new
    # if !Rails.application.config.anagrammer
    #   render 'initialize'
    #   puts "Loading dictionary..."
    #   Rails.application.config.anagrammer = Anagrammer.new
    # end
  end

  def create
    @anagram_text = params[:text]
    session[:subject] = params[:text]
    session[:current_anagram] = ""
    redirect_to action: 'show', text: @anagram_text
  end

  def save
    print "Params: "
    p params
    # a = Rails.application.config.anagrammer
    subject_text = Word.new(session[:subject])
    anagram_text = session[:current_anagram]
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

  def reset
    session[:current_text] = session[:subject]
    session[:current_anagram] = ""
    redirect_to :back

    # @response = {
    #   text: session[:current_text],
    #   current: session[:current_anagram],
    #   subwords: [],
    #   anagrams: [],
    #   status: "subword"
    # }
    # respond_to do |format|
    #   format.html do
    #     redirect_to "/anagrams/#{a.current_text}"
    #   end
    #   format.json { render json: @response, status: :ok}
    # end
  end

  def show
    # if !Rails.application.config.anagrammer
    #   redirect_to action: 'new'
    # else
      session[:current_text] = params[:text]
      puts "Getting text to anagram:"
      @text = Word.new(params[:text])
      puts @text
      # a = Rails.application.config.anagrammer
      @current = session[:current_anagram]
      @current_words = @current.split
      puts "Generating anagrams..."
      a = Anagrammer.new(@text)
      @subwords = a.current_subwords
      @anagrams = a.current_anagrams
    # end
  end

end
