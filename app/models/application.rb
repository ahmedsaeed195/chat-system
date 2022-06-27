class Application < ApplicationRecord
  has_many :chats, dependent: :destroy
  validates :chats_count, numericality: { greater_than_or_equal_to: 0 }
end
