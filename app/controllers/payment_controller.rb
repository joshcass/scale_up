class PaymentController < ApplicationController
  #current user find loan request and then pay on it
  def update
    Resque.enqueue(LoanRequestPayJob, current_user.id, params[:id], params[:payment])
    flash[:notice] = "Thank you for your payment. You have #{loan_request.remaining_payments} left."
    redirect_to portfolio_path
  end
end
