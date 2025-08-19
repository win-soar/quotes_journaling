class LineEvent < ApplicationRecord
  validates :event_type, presence: true
  validates :user_id, presence: true
  validates :payload, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "event_type", "id", "message", "payload", "updated_at", "user_id"]
  end

  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :message_events, -> { where(event_type: 'message') }

  def message_text
    payload.dig('message', 'text') if payload.is_a?(Hash)
  end

  def source_type
    payload.dig('source', 'type') if payload.is_a?(Hash)
  end

  def event_summary
    case event_type
    when 'message'
      "メッセージ受信: #{message_text&.truncate(30) || '（テキストなし）'}"
    else
      "#{event_type}イベント"
    end
  end
end
