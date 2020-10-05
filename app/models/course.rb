class Course < ApplicationRecord
  include PublicActivity::Model
  extend FriendlyId

  belongs_to :user

  has_many :lessons, dependent: :destroy
  has_many :enrollments

  validates :title, :language, :level, presence: true
  validates :short_description, presence: true, length: { minimum: 5, maximum: 300 }
  validates :description, presence: true, length: { minimum: 5 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  LANGUAGES = %i(English Russian)
  LEVELS = %i(Beginner Intermediate Advanced)

  has_rich_text :description
  friendly_id :title, use: :slugged
  # friendly_id :generated_slug, use: :slugged

  tracked owner: Proc.new{ |controller, model| controller.current_user }

  def self.languages
    LANGUAGES.map { |lang| [lang, lang] }
  end

  def self.levels
    LEVELS.map { |level| [level, level] }
  end

  def is_bought?(user)
    self.enrollments.where(user_id: [user.id], course_id: [self.id]).present?
  end

  # def generated_slug
  #   require "securerandom"
  #   @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(4)
  # end
end
