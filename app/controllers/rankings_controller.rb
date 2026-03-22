class RankingsController < ApplicationController
  before_action :redirect_circle_user!

  def total_likes
    @ranking = Like.total_ranking
  end

  def weekly_likes
    @ranking = Like.weekly_ranking
  end

  private

  def redirect_circle_user!
    redirect_to circle_quotes_path(current_circle) if circle_mode?
  end
end
