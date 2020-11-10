class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable, :omniauthable,
         omniauth_providers: [:google_oauth2]
  rolify

  extend FriendlyId
  friendly_id :email, use: :slugged

  has_many :courses, dependent: :nullify
  has_many :enrollments, dependent: :nullify
  has_many :user_lessons, dependent: :nullify
  has_many :comments, dependent: :nullify

  validate :must_have_a_role, on: :update

  after_create :assign_default_role

  def username
    self.email.split(/@/).first
  end

  def online?
    updated_at > 2.minutes.ago
  end

  def buy_course(course)
    self.enrollments.create!(course: course, price: course.price)
  end

  def view_lesson(lesson)
    user_lesson = self.user_lessons.where(lesson: lesson)

    if user_lesson.any?
      user_lesson.first.increment!(:impression)
    else
      self.user_lessons.create(lesson: lesson)
    end
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    if user
      user.name = access_token.info.name
      user.provider = access_token.provider
      user.uid = access_token.uid
      user.image = access_token.info.image
      user.token = access_token.credentials.token
      user.expires_at = access_token.credentials.expires_at
      user.expires = access_token.credentials.expires
      user.refresh_token = access_token.credentials.refresh_token
      user.save!
    else
      user = User.create(email: data['email'],
                         password: Devise.friendly_token[0,20],
                         confirmed_at: Time.now # auto-confirm account
      )
    end
    user
  end

  private

  def assign_default_role
    if User.count == 1
      self.add_role(:admin) if self.roles.blank?
      self.add_role(:teacher)
      self.add_role(:student)
    else
      self.add_role(:student) if self.roles.blank?
      self.add_role(:teacher)
    end
  end

  def must_have_a_role
    unless roles.any?
      errors.add(:roles, "Must have at least one role")
    end
  end
end
