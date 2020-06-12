class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :post

  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true, uniqueness: { scope: :post_id }
  validates :post_id, presence: true
end
