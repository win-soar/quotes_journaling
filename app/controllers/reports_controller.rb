class ReportsController < ApplicationController
  def new
    @reportable = find_reportable
    @report = Report.new
  end

  def create
    @reportable = find_reportable
    @report = @reportable.reports.build(report_params)
    @report.user = current_user

    if @report.save
      redirect_to root_path, notice: '通報を受け付けました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def report_params
    params.require(:report).permit(:reason)
  end

  def find_reportable
    if params[:quote_id]
      Quote.find(params[:quote_id])
    elsif params[:comment_id]
      Comment.find(params[:comment_id])
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
