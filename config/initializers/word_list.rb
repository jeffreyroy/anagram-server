# require_relative '../app/models/anagrammer'

module InitWordList
  class Application < Rails::Application
    config.after_initialize do
      config.blurb = "Loading dictionary..."
      config.anagrammer = Anagrammer.new
    end
  end
end