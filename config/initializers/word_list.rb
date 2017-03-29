# require_relative '../app/models/anagrammer'

module InitWordList
  class Application < Rails::Application
    # Initialize word list
    config.after_initialize do
      config.blurb = "Loading dictionary..."
      config.anagrammer = Anagrammer.new
    end
  end
end