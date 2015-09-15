class LoanRequestPayJob
  @queue = :loan_request_pay

  def perform(user_id, loan_request_id, payment_amount)
    user = User.find(user_id)
    loan_request = user.loan_requests.find(loan_request_id)

    if loan_request.pay!(payment_amount.to_i, user)
      # send success email
    else
      #send fail email
    end
  end
end
