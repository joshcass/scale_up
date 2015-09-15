require "rails_helper"

RSpec.describe Order, type: :model do
  context "valid attributes" do
    let!(:loan_request) { LoanRequest.create(title: "Farm Tools",
                                             description: "help out with the farm tools",
                                             amount: "100",
                                             requested_by_date: "2015-06-01",
                                             repayment_begin_date: "2015-12-01",
                                             contributed: "50",
                                             repayment_rate: "monthly",
                                             user_id: borrower.id)
    }
    let(:borrower) { User.create(email: "example@example.com", password: "password", name: "sally", role: 1) }
    let(:lender) { User.create(email: "joe@example.com", password: "password", name: "joe", role: 0) }
    let(:order) { Order.create(user_id: "#{lender.id}", cart_items: { "#{loan_request.id }" => 25 }) }

    scenario "it is valid" do
      expect(order).to be_valid
    end

    scenario "it formats the dates" do
      expect(order.created_at_formatted.class).to eq(String)
      expect(order.updated_at_formatted.class).to eq(String)
    end

    it 'can update contributed users' do
      order.update_contributed(lender)
      expect(lender.total_contributed).to eq(25)
    end
  end

  context "invalid attributes" do
    it "is invalid without any attributes" do
      order = Order.new
      expect(order).to_not be_valid
    end

    it "is invalid without a user_id" do
      order = Order.new(cart_items: "{'9'=>1}")
      expect(order).to_not be_valid
    end

    it "is invalid without cart_items" do
      order = Order.new(user_id: 1)
      expect(order).to_not be_valid
    end
  end
end
