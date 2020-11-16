class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true

  has_many :user_lessons, dependent: :destroy
  has_many :comments, dependent: :nullify

  has_one_attached :video

  include RankedModel
  ranks :row_order, with_same: :course_id

  extend FriendlyId
  friendly_id :title, use: :slugged

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  validates :title, :content, :course_id, presence: true
  validates :title, length: { maximum: 50 }
  validates :video, content_type: ['video/mp4'],
            size: { less_than: 50.megabytes , message: 'Must be less 50 MB' }
  validates_uniqueness_of :title, scope: :course_id

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
