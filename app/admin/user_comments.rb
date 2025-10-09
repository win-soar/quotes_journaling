ActiveAdmin.register Comment, as: "UserComment" do
  permit_params :body, :user_id, :quote_id

  index do
    selectable_column
    id_column
    column :body
    column :user
    column :quote
    column :created_at
    actions
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