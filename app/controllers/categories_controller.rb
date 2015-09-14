class CategoriesController < ApplicationController

  def show
    @category = Category.find(params[:id])
    @categories = Category.all
    @loan_requests = @category.loan_requests.paginate(:page => params[:page], :per_page => 30)
  end
end
