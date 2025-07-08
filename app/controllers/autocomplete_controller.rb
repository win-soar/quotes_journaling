class AutocompleteController < ApplicationController
  def index
    field = params[:field]
    query = params[:query]

    if %w[title author source source_writer].include?(field) && query.present?
      results = Quote.where("#{field} ILIKE ?", "%#{query}%")
                     .distinct
                     .limit(10)
                     .pluck(field)
    else
      results = []
    end

    render json: results
  end
end
