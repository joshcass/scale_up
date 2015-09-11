class LoanRequestsContributor < ActiveRecord::Base
  belongs_to :loan_request
  belongs_to :user, touch: true

  def newest_contribution
    updated_at.strftime("%B %d, %Y")
  end
end
