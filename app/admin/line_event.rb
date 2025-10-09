ActiveAdmin.register LineEvent do
  menu priority: 5, label: "LINEイベント"

  actions :index, :show

  # 独自削除アクション
  member_action :delete, method: :post do
    resource.destroy
    redirect_to admin_line_events_path, notice: 'LINEイベントを削除しました'
  end

  index do
    selectable_column
    id_column
    column :event_type
    column :user_id
    column :event_summary
    column :created_at
    actions defaults: false do |line_event|
      form_tag(delete_admin_line_event_path(line_event), method: :post, style: "display: inline;") do
        submit_tag('削除', data: { confirm: '本当に削除しますか？' }, style: 'margin-left: 8px;')
      end
    end
  end

  show do
    attributes_table do
      row :id
      row :event_type
      row :user_id
      row :message_text
      row :source_type
      row :created_at
      row :updated_at
      row :payload do |event|
        pre JSON.pretty_generate(event.payload)
      end
    end
  end

  filter :event_type
  filter :user_id
  filter :created_at

  controller do
    def scoped_collection
      super.recent
    end

    def permitted_params
      params.permit!
    end
  end
end
