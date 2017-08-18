class SubwordsController < ApplicationController


  def add
    subword = params[:subword]
    puts "Adding subword #{subword}"
    @text = session[:current_text]
    # a = Rails.application.config.anagrammer
    a = Anagrammer.new(@text)
    @response = a.add_to_anagram(subword, session[:current_anagram])
    status = @response[:status]
    respond_to do |format|
      if status != "fail"
        # It's a subword
        session[:current_text] = a.current_text
        session[:current_anagram] = @response[:current]
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


  def remove
    subword = params[:subword]
    puts "Removing subword #{subword}"
    @text = session[:current_text]
    # a = Rails.application.config.anagrammer
    a = Anagrammer.new(@text)
    @response = a.remove_from_anagram(subword, session[:current_anagram])
    status = @response[:status]
    respond_to do |format|
      if status != "fail"
        # It's a subword
        session[:current_text] = session[:current_text] + subword
        session[:current_anagram] = @response[:current]
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
