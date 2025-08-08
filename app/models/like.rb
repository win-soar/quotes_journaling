class Like < ApplicationRecord
  belongs_to :user
  belongs_to :quote

  validates :user_id, uniqueness: { scope: :quote_id }

  # 通算いいね数ランキング用スコープ
  scope :total_ranking, lambda { |limit = 30|
    select('quote_id, count(*) as likes_count')
      .group(:quote_id)
      .order('likes_count DESC')
      .limit(limit)
  }

  # 週間いいね数ランキング用スコープ
  scope :weekly_ranking, lambda { |limit = 10|
    where('created_at >= ?', 1.week.ago)
      .select('quote_id, count(*) as likes_count')
      .group(:quote_id)
      .order('likes_count DESC')
      .limit(limit)
  }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "quote_id", "updated_at", "user_id"]
  end
end
