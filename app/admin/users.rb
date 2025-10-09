ActiveAdmin.register User do
  # 独自削除アクション
  member_action :delete, method: :post do
    resource.destroy
    redirect_to admin_users_path, notice: 'ユーザーを削除しました'
  end

  remove_filter :liked_quotes, :avatar_attachment, :avatar_blob, :provider

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :created_at
    actions defaults: false do |user|
      span link_to('編集', edit_admin_user_path(user), style: 'margin-right: 8px;')
      form_tag(delete_admin_user_path(user), method: :post, style: "display: inline;") do
        submit_tag('削除', data: { confirm: '本当に削除しますか？' }, style: 'margin-left: 8px;')
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
