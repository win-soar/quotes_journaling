require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user)  { User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password', name: 'テストマン') }
  let(:quote) { Quote.create!(title: '名言', note: 'note', author: 'author', source: 'source', user: user, category: 1) }

  describe 'バリデーション' do
    it 'ユーザーと投稿があれば有効である' do
      like = Like.new(user: user, quote: quote)
      expect(like).to be_valid
    end

    it 'ユーザーがなければ無効である' do
      like = Like.new(user: nil, quote: quote)
      expect(like).not_to be_valid
    end

    it '投稿がなければ無効である' do
      like = Like.new(user: user, quote: nil)
      expect(like).not_to be_valid
    end

    it '同じユーザーが同じ投稿に2回いいねすると無効である' do
      Like.create!(user: user, quote: quote)
      duplicate_like = Like.new(user: user, quote: quote)
      expect(duplicate_like).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:quote) }
    it { should belong_to(:user) }
  end
end
