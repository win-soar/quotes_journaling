require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user)  { User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password', name: 'テストマン') }
  let(:quote) { Quote.create!(title: '名言', note: 'note', author: 'author', source: 'source', user: user, category: 1) }

  describe 'バリデーション' do
    it 'ユーザーがなければ無効である' do
      comment = Comment.new(user: nil, quote: quote, body: 'コメント本体')
      expect(comment).not_to be_valid
    end

    it 'コメント内容がなければ無効である' do
      comment = Comment.new(user: user, quote: quote, body: '')
      expect(comment).not_to be_valid
    end

    it 'すべての項目が揃っていれば有効である' do
      comment = Comment.new(user: user, quote: quote, body: 'コメント本体')
      expect(comment).to be_valid
    end
  end
end
