ActiveAdmin.register User do
  remove_filter :liked_quotes, :avatar_attachment, :avatar_blob

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      # f.input :password
    end
    f.actions
  end
end
