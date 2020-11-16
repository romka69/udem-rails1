class Comment < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :lesson, counter_cache: true

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  validates :content, presence: true
  validates :content, length: { minimum: 3, maximum: 250 }
end
