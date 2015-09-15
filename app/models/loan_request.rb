class LoanRequest < ActiveRecord::Base
  validates :title, :description, :amount,
    :requested_by_date, :repayment_begin_date,
    :repayment_rate, :contributed, presence: true
  has_many :orders
  has_many :loan_requests_contributors
  has_many :users, through: :loan_requests_contributors
  has_many :loan_requests_categories
  has_many :categories, through: :loan_requests_categories
  belongs_to :user
  enum status: %w(active funded)
  enum repayment_rate: %w(monthly weekly)
  before_create :assign_default_image

  def assign_default_image
    self.image_url = DefaultImages.random if self.image_url.nil? || self.image_url.empty?
  end

  def owner
    self.user.name
  end

  def repayment_begin
    self.repayment_begin_date.strftime("%B %d, %Y")
  end

  def funding_remaining
    amount - contributed
  end

  def self.projects_with_contributions
    where("contributed > ?", 0)
  end

  def minimum_payment
    if repayment_rate == "weekly"
      (contributed - repayed) / 12
    else
      (contributed - repayed) / 3
    end
  end

  def repayment_due_date
    (repayment_begin_date + 12.weeks).strftime("%B %d, %Y")
  end

  def pay!(amount, borrower)
    repayment_percentage = (amount / contributed.to_f)
    project_contributors.each do |lender|
      repayment = lender.contributed_to(self.id).first.contribution * repayment_percentage
      lender.increment!(:purse, repayment)
      borrower.decrement!(:purse, repayment)
      self.increment!(:repayed, repayment)
    end
  end

  def remaining_payments
    (contributed - repayed) / minimum_payment
  end

  def project_contributors
    User.where(id: LoanRequestsContributor.where(loan_request_id: self.id).pluck(:user_id))
  end

  def related_projects
    categories.first.loan_requests.where.not(id: id).offset(rand(100)).limit(4)
  end
end
