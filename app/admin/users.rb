ActiveAdmin.register User do
  # LINEテスト送信カスタムアクション
  member_action :send_test_message, method: :post do
    if resource.line_user_id.present?
      DailyPostRecommendation.send_test_message_to_user(resource.line_user_id)
      redirect_to admin_users_path, notice: "LINEテストメッセージを送信しました (user_id: #{resource.line_user_id})"
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
