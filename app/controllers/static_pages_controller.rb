class StaticPagesController < ApplicationController
  begin
    skip_before_action :authenticate_user!, raise: false
  rescue StandardError
    nil
  end

  def terms
  end

  def privacy_policy
  end

  def guide
  end
end
