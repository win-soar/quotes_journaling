class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: [:terms, :privacy_policy]

  def terms
  end

  def privacy_policy
  end
end
