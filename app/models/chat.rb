class Chat < ApplicationRecord
  belongs_to :application, counter_cache: true
  has_many :messages, dependent: :destroy
  validates :messages_count, numericality: { greater_than_or_equal_to: 0 }
end
