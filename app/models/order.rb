class Order < ActiveRecord::Base
  validates :user_id, :cart_items, presence: true
  belongs_to :user
  enum status: %w(ordered paid cancelled completed)
  validate :not_over_funded

  def not_over_funded
    return if errors.any?
    cart_item_and_quantity.keys.each do |loan_request|
      unless (loan_request.contributed + cart_items[loan_request.id.to_s].to_i) <= loan_request.amount
        errors.add("#{loan_request.title}", "only needs $#{loan_request.amount}. Please subtract $#{(loan_request.funding_remaining).abs} from your donation.")
      end
    end
  end

  def created_at_formatted
    created_at.strftime("%A, %d %b %Y %l:%M %p")
  end

  def updated_at_formatted
    updated_at.strftime("%A, %d %b %Y %l:%M %p")
  end

  def cart_item_and_quantity
    cart_items.reduce({}) do |hash, (loan_request_id, amount)|
      hash[LoanRequest.find(loan_request_id)] = amount
      hash
    end
  end

  def update_contributed(user)
    cart_item_and_quantity.each do |loan_request, contribution|
      associate_user_with_loan_request(user, loan_request.id, contribution)
      loan_request.update_attributes(contributed: loan_request.contributed += contribution.to_i)
    end
  end

  def associate_user_with_loan_request(user, loan_request_id, contribution)
    user.contributed_to(loan_request_id).
      first_or_create.increment!(:contribution, contribution.to_i)
  end

  def send_contributed_to_email
    cart_item_and_quantity.each do |loan_request, _|
      user = User.find(loan_request.user_id)
      BorrowerMailer.project_contributed_to(user, loan_request.title).deliver_now
    end
  end
end
