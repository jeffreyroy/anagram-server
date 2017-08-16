# require_relative '../app/models/anagrammer'

module InitWordList
  class Application < Rails::Application
    # Initialize word list
    config.after_initialize do
      config.blurb = "Initializing dictionary..."
      config.anagrammer = nil
    end
  end
end