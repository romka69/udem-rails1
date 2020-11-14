class Enrollment < ApplicationRecord
  belongs_to :course, counter_cache: true
  belongs_to :user, counter_cache: true

  validates :user, :course, presence: true, on: :update
  validates :rating, :review, presence: true, on: :update
  validates_uniqueness_of :user_id, scope: :course_id
  validates_uniqueness_of :course_id, scope: :user_id
  validate :cant_subscribe_to_own_course

  after_create :calculate_balance

  after_save do
    course.update_rating unless rating.nil? || rating.zero?
  end

  after_destroy :calculate_balance

  after_destroy do
    course.update_rating
  end

  scope :pending_review, -> { where(rating: [0, nil, ""], review: [0, nil, ""]) }
  scope :reviewed, -> { where.not(review: [0, nil, ""]) }
  scope :latest_reviews, -> { order(rating: :desc, created_at: :desc).limit(3) }

  extend FriendlyId
  friendly_id :to_s, use: :slugged

  def to_s
    "#{user.username} - #{course.title}"
  end

  private

  def cant_subscribe_to_own_course
    if self.new_record?
      if user_id.present?
        if user_id == course.user_id
          errors.add(:base, "You can not subscribe to yor own course.")
        end
      end
    end
  end

  def calculate_balance
    course.calculate_income
    user.calculate_enrollment_expences
  end
end
