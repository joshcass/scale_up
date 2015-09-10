class AddDualIndexToLoanRequestContributions < ActiveRecord::Migration
  def change
    add_index :loan_requests_contributors, [:user_id, :loan_request_id]
  end
end
