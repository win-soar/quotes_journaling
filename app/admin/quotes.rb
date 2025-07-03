ActiveAdmin.register Quote do
  remove_filter :image

  index do
    selectable_column
    id_column
    column :title
    column :author
    column :category
    column :user
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :author
      f.input :note
      f.input :source
      f.input :source_writer
      f.input :category
      f.input :user
    end
    f.actions
  end
end
