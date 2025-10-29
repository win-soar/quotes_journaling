class SchedulerController < ApplicationController
  skip_before_action :authenticate_user!

  def run_daily
    return head :forbidden unless params[:token] == ENV['SCHEDULER_TOKEN']

    DailyPostRecommendation.send_daily_recommendations
    render plain: "Daily recommendations sent successfully"
  end
end
