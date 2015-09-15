class PaymentController < ApplicationController
  #current user find loan request and then pay on it
  def update
    loan_request = current_user.loan_requests.find(params[:id])
    Resque.enqueue(LoanRequestPayJob, current_user.id, params[:id], params[:payment])
    flash[:notice] = "Thank you for your payment. You have #{loan_request.remaining_payments} left."
    redirect_to portfolio_path
  end
end
