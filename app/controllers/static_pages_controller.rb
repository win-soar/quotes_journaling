class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, raise: false rescue nil

  def terms
  end

  def privacy_policy
  end

  def guide
  end
end
