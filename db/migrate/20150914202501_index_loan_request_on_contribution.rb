class IndexLoanRequestOnContribution < ActiveRecord::Migration
  def change
    add_index :loan_requests, :contributed
  end
end
