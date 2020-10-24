class Course < ApplicationRecord
  include PublicActivity::Model
  extend FriendlyId

  belongs_to :user, counter_cache: true

  has_many :lessons, dependent: :destroy
  has_many :enrollments, dependent: :restrict_with_error
  has_many :user_lessons, through: :lessons

  validates :title, :language, :level, presence: true
  validates :title, uniqueness: true
  validates :short_description, presence: true, length: { minimum: 5, maximum: 300 }
  validates :description, presence: true, length: { minimum: 5 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :top_rated, -> { order(average_rating: :desc, created_at: :desc).limit(3) }
  scope :popular, -> { order(enrollments_count: :desc, created_at: :desc).limit(3) }
  scope :latest, -> { order(created_at: :desc).limit(3) }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }

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

  def update_rating
    if self.enrollments.any? && self.enrollments.where.not(rating: nil).any?
      update_column :average_rating, (self.enrollments.average(:rating).round(2).to_f)
    else
      update_column :average_rating, (0)
    end
  end

  def progress(user)
    unless self.lessons_count.zero?
      user_lessons.where(user: user).count / self.lessons_count.to_f * 100
    end
  end

  # def generated_slug
  #   require "securerandom"
  #   @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(4)
  # end
end
