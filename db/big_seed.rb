require 'populator'

module BigSeed
  class Seed
    CATEGORIES = ["agriculture", "community", "education", "technology", "automotive", "retail", "b2b", "recreation", "helping", "growing", "caring", "farming", "livestock", "dairy", "recycling"]
    DONATION_AMOUNTS = %w(25, 50, 75, 100, 125, 150, 175, 200)

    def run
      create_categories
      10.times {create_borrowers}
      20.times {create_lenders}
      50.times {create_requests}
      20.times {create_orders}
    end

    def create_categories
      CATEGORIES.each do |cat|
        Category.create(title: cat, description: cat + " stuff")
      end
    end

    def create_borrowers
      User.populate(3000) do |user|
        user.name = Faker::Name.name
        user.email = Faker::Internet.email
        user.password_digest = "$2a$10$3Wc7siVIXIt.myPQyRkNHenNDZc6bDT7LcSZvO75eWFfKyVgQb8T2"
        user.role = 1
      end
      puts 'created 3000 borrowers'
    end

    def borrower_ids
      @borrower_ids ||= User.where(role: 1).pluck(:id)
    end

    def category_ids
      @category_ids ||= Category.pluck(:id)
    end

    def create_requests
      LoanRequest.populate(10000) do |request|
        request.user_id = borrower_ids.sample
        request.description = Faker::Company.catch_phrase
        request.status = [0, 1]
        request.amount = 100..2000
        request.requested_by_date = Faker::Time.between(7.days.ago, 3.days.ago)
        request.contributed = 0
        request.repayment_rate = [0, 1]
        request.repayment_begin_date = Faker::Time.between(3.days.ago, Time.now)
        LoanRequestsCategory.populate(4) do |request_cat|
          request_cat.loan_request_id = request.id
          request_cat.category_id = category_ids.sample
        end
      end
      puts 'created 10000 requests'
    end

    def create_lenders
      User.populate(10000) do |user|
        user.name = Faker::Name.name
        user.email = Faker::Internet.email
        user.password_digest = "$2a$10$3Wc7siVIXIt.myPQyRkNHenNDZc6bDT7LcSZvO75eWFfKyVgQb8T2"
        user.role = 0
      end
      puts 'created 10000 lenders'
    end

    def lenders
      @lenders ||= User.where(role: 0)
    end

    def loan_request_ids
      @loan_requests ||= LoanRequest.pluck(:id)
    end

    def create_orders
      orders = []
      5000.times do
        donation = DONATION_AMOUNTS.sample
        lender = lenders.sample
        request_id = loan_request_ids.sample
        order = Order.new(cart_items:
          { "#{request_id}" => donation },
          user_id: lender.id)
        order.update_contributed(lender)
        orders << order
      end
      orders.each { |o| o.save}
      puts 'created 10000 orders'
    end
  end
end
