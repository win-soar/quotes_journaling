class RankingsController < ApplicationController
  def total_likes
    @ranking = Like.total_ranking
  end

  def weekly_likes
    @ranking = Like.weekly_ranking
  end
end
