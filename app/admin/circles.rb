ActiveAdmin.register Circle do
  permit_params :name, :description, :circle_password, :circle_password_confirmation

  # circle_password_digest は has_secure_password が追加したカラムのためフィルター除外
  filter :name
  filter :description
  filter :created_at

  index do
    selectable_column
    id_column
    column :name
    column :description
    column('参加URL') { |c| link_to circle_join__signup_path(join_token: c.join_token), circle_join__signup_path(join_token: c.join_token) }
    column('メンバー数') { |c| c.member_count }
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row('参加URL') do |c|
        path = circle_join__signup_path(join_token: c.join_token)
        link_to path, path
      end
      row('メンバー数') { |c| c.member_count }
      row :join_token
      row :created_at
      row :updated_at
    end

    panel 'メンバー一覧' do
      table_for resource.users.order(created_at: :asc) do
        column :name
        column :email
        column('参加日') { |u| u.created_at.in_time_zone('Tokyo').strftime('%Y-%m-%d') }
      end
    end
  end

  form do |f|
    f.inputs 'サークル情報' do
      f.input :name, label: 'サークル名'
      f.input :description, label: '説明'
      f.input :circle_password, as: :string, input_html: { type: 'password' }, label: 'サークルパスワード'
      f.input :circle_password_confirmation, as: :string, input_html: { type: 'password' }, label: 'サークルパスワード（確認）'
    end
    f.actions
  end
end
