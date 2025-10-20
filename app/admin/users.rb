ActiveAdmin.register User do
  member_action :send_test_message, method: :post do
    if resource.line_user_id.present?
      begin
        message = Line::Bot::V2::MessagingApi::TextMessage.new(
          text: "管理者からのテストメッセージです"
        )

        request = Line::Bot::V2::MessagingApi::PushMessageRequest.new(
          to: resource.line_user_id,
          messages: [message]
        )

        LineClientService.messaging_api_client.push_message(
          push_message_request: request
        )

        redirect_to admin_users_path, notice: "LINEテストメッセージを送信しました (user_id: #{resource.line_user_id})"
      rescue => e
        redirect_to admin_users_path, alert: "LINEメッセージ送信に失敗しました: #{e.message}"
      end
    else
      redirect_to admin_users_path, alert: 'このユーザーはLINE連携されていません。'
    end
  end

  member_action :send_recommendation, method: :post do
    if resource.line_user_id.present?
      quote = DailyPostRecommendation.find_recommended_quote
      if quote
        DailyPostRecommendation.send_recommendation(resource, quote)
        redirect_to admin_users_path, notice: "おすすめ投稿を送信しました (user_id: #{resource.line_user_id})"
      else
        redirect_to admin_users_path, alert: "おすすめ投稿が見つかりませんでした"
      end
    else
      redirect_to admin_users_path, alert: 'このユーザーはLINE連携されていません。'
    end
  end

  remove_filter :liked_quotes, :avatar_attachment, :avatar_blob, :provider
  index do
    selectable_column
    id_column
    column :name
    column :email
    column :created_at
    actions defaults: true do |user|
      if user.line_user_id.present?
        link_to 'LINEテスト送信', send_test_message_admin_user_path(user), method: :post, data: { confirm: 'このユーザーにLINEテストメッセージを送信します。よろしいですか？' }
        link_to 'おすすめ投稿送信', send_recommendation_admin_user_path(user), method: :post, data: { confirm: 'このユーザーにおすすめ投稿を送信します。よろしいですか？' }
      end
    end
  end
  filter :provider
  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      # f.input :password
    end
    f.actions
  end
end