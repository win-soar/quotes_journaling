class Circles::MembersController < Circles::BaseController
  def index
    @circle = current_circle
    @members = current_circle.users.order(created_at: :asc)
  end
end
