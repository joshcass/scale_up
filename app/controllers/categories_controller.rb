class CategoriesController < ApplicationController

  def show
    @category = Category.find(params[:id])
    @categories = Category.all_categories
    @loan_requests = @category.loan_requests.paginate(page: params[:page], per_page: 30, total_entries: @category.loan_requests_categories.size)
  end
end
