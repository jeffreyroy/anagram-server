class Subject < ApplicationRecord
  has_many :anagrams
  validates :subject_text, presence: true
  before_save :alphabetize

  private

  def alphabetize
    w = Word.new(subject_text)
    self.alphabetized = w.a
  end

end
