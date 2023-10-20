class AuthorsController < ApplicationController
  def index
    @authors = Author.all
    @filterrific = initialize_filterrific(
      Author,
      params[:filterrific],
      select_options: {
        sorted_by: Author.options_for_sorted_by
      }
    ) or return

    @authors = @filterrific.find.paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html
      format.js
    end
  end
end
