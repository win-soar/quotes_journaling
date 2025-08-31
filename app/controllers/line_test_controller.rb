class LineTestController < ApplicationController
  # GET /line_test/send_test_message?user_id=xxxx
  def send_test_message
    user_id = params[:user_id]
    result = DailyPostRecommendation.send_test_message_to_user(user_id)
    render plain: "送信結果: #{result.inspect}"
  end
end
