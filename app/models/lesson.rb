class Lesson < ApplicationRecord
  belongs_to :course

  validates :title, :content, :course_id, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  has_rich_text :content
end
