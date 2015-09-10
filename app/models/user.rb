class User < ActiveRecord::Base
  has_secure_password
  validates_confirmation_of :password
  validates :password, length: { minimum: 8 }
  validates :password, :name, :email, presence: true
  validates :email, uniqueness: true
  validates_format_of :email, with: /.+@.+\..+/i

  enum role: %w(lender borrower admin)

  has_many :orders
  has_many :loan_requests
  has_many :loan_requests_contributors
  has_many :projects, through: :loan_requests_contributors, source: "loan_request"
  before_save :format_name

  def format_name
    write_attribute(:name, name.to_s.titleize)
  end

  def total_contributed
    Rails.cache.fetch("total_contributed_#{self.updated_at}") do
      loan_requests_contributors.sum(:contribution)
    end
  end

  def total_contributions_received
    Rails.cache.fetch("total_contributions_#{self.updated_at}") do
      loan_requests.sum(:contributed)
    end
  end

  def contributed_to(loan_request)
    LoanRequestsContributor.lender_contribution(self.id, loan_request)
  end
end
