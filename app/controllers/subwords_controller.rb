class SubwordsController < ApplicationController


  def add
    subword = params[:subword]
    puts "Adding subword #{subword}"
    a = Rails.application.config.anagrammer
    @response = a.add_to_anagram(subword)
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


  def remove
    subword = params[:subword]
    puts "Removing subword #{subword}"
    a = Rails.application.config.anagrammer
    @response = a.remove_from_anagram(subword)
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
