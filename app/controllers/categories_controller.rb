class CategoriesController < ApplicationController

  def show
    @category = Category.find(params[:id])
    @categories = Category.all_categories
    @loan_requests = @category.all_requests.paginate(:page => params[:page], :per_page => 30)
  end
end
