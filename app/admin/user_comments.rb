ActiveAdmin.register Comment, as: "UserComment" do
  permit_params :body, :user_id, :quote_id

  # 独自削除アクション
  member_action :delete, method: :post do
    resource.destroy
    redirect_to admin_user_comments_path, notice: 'コメントを削除しました'
  end

  index do
    selectable_column
    id_column
    column :body
    column :user
    column :quote
    column :created_at
    actions defaults: false do |user_comment|
      span link_to('編集', edit_admin_user_comment_path(user_comment), style: 'margin-right: 8px;')
      form_tag(delete_admin_user_comment_path(user_comment), method: :post, style: "display: inline;") do
        submit_tag('削除', data: { confirm: '本当に削除しますか？' }, style: 'margin-left: 8px;')
      end
    end
  end

  filter :user
  filter :quote
  filter :created_at

  form do |f|
    f.inputs do
      f.input :body
      f.input :user
      f.input :quote
    end
    f.actions
  end
end