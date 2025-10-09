ActiveAdmin.register Quote do
  remove_filter :image

  # 独自削除アクション
  member_action :delete, method: :post do
    resource.destroy
    redirect_to admin_quotes_path, notice: '名言を削除しました'
  end

  index do
    selectable_column
    id_column
    column :title
    column :author
    column :category
    column :user
    column :created_at
    actions defaults: false do |quote|
      span link_to('編集', edit_admin_quote_path(quote), style: 'margin-right: 8px;')
      form_tag(delete_admin_quote_path(quote), method: :post, authenticity_token: true, style: "display: inline;") do
        submit_tag('削除', data: { confirm: '本当に削除しますか？' }, style: 'margin-left: 8px;')
      end
    end
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
