class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true

  has_many :user_lessons, dependent: :destroy

  validates :title, :content, :course_id, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  include RankedModel
  ranks :row_order, with_same: :course_id

  has_rich_text :content

  def viewed?(user)
    self.user_lessons.where(user: user).present?
  end

  def prev_element
    course.lessons.where("row_order < ?", row_order).order(:row_order).last
  end

  def next_element
    course.lessons.where("row_order > ?", row_order).order(:row_order).first
  end
end
