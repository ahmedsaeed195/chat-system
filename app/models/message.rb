class Message < ApplicationRecord
  belongs_to :chat, counter_cache: true

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings index: { number_of_shards: 1 } do
    mapping dynamic: 'false' do
      indexes :id, type: :integer
      indexes :message_no, type: :integer
      indexes :sender
      indexes :content
      indexes :chat_id, type: :integer
      indexes :created_at, type: :date, format: :date_optional_time
      indexes :updated_at, type: :date, format: :date_optional_time
    end
  end

  # def self.search(query)
  #   __elasticsearch__.search(
  #     {
  #       query: {
  #         match: {
  #           query: { match: { content: { query: query, operator: 'and' } } },
  #           fields: ['content']
  #         }
  #       }
  #     }
  #   )
  # end

  # Delete the previous articles index in Elasticsearch
  begin
    Message.__elasticsearch__.delete_index!
  rescue StandardError
    nil
  end
end
# Create the new index with the new mapping
Message.__elasticsearch__.create_index!
# Index all article records from the DB to Elasticsearch
Message.import
