ActiveAdmin.register Report do
  includes :user, :reportable

  # 独自削除アクション
  member_action :delete, method: :post do
    resource.destroy
    redirect_to admin_reports_path, notice: '通報を削除しました'
  end

  index do
    selectable_column
    id_column
    column :user
    column("対象") do |report|
      case report.reportable_type
      when "Quote"
        link_to truncate(report.reportable.title, length: 30), admin_quote_path(report.reportable_id)
      when "Comment"
        comment = report.reportable
        link_to truncate(comment.body, length: 30), admin_user_comment_path(comment.id)
      else
        "不明"
      end
    end
    column :reason
    column :created_at
    actions defaults: false do |report|
      form_tag(delete_admin_report_path(report), method: :post, authenticity_token: true, style: "display: inline;") do
        submit_tag('削除', data: { confirm: '本当に削除しますか？' }, style: 'margin-left: 8px;')
      end
    end
  end

  show do
    attributes_table do
      row :id
      row :user
      row("対象") do |report|
        case report.reportable_type
        when "Quote"
          quote = report.reportable
          link_to "#{quote.user.name}のコメント: #{truncate(quote.title, length: 50)}", admin_quote_path(quote)
        when "Comment"
          comment = report.reportable
          link_to "#{comment.user.name}のコメント: #{truncate(comment.body, length: 50)}", admin_user_comment_path(comment)
        else
          "不明な対象"
        end
      end
      row :reason
      row :created_at
      row :updated_at
    end
  end

  controller do
    def scoped_collection
      super.includes(:user, :reportable)
    end
  end
end
