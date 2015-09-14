require "logger"
require "pry"
require "capybara"
require 'capybara/poltergeist'
require "faker"
require "active_support"
require "active_support/core_ext"

module LoadScript
  class Session
    include Capybara::DSL
    attr_reader :host
    CATEGORIES = ["agriculture", "community", "education", "technology", "automotive", "retail", "b2b", "recreation", "helping", "growing", "caring", "farming", "livestock", "dairy", "recycling"]
    EMAILS= ["demo+horace@jumpstartlab.com", "name@name.com", "joe@joe.com", "email@email.com", "stuff@things.com", "hello@world.com", "woo@hoo.com"]

    def initialize(host = nil)
      Capybara.default_driver = :poltergeist
      @host = host || "http://localhost:3000"
    end

    def logger
      @logger ||= Logger.new("./log/requests.log")
    end

    def session
      @session ||= Capybara::Session.new(:poltergeist)
    end

    def run
      while true
        run_action(actions.sample)
      end
    end

    def run_action(name)
      benchmarked(name) do
        send(name)
      end
    rescue Capybara::Poltergeist::TimeoutError
      logger.error("Timed out executing Action: #{name}. Will continue.")
    end

    def benchmarked(name)
      logger.info "Running action #{name}"
      start = Time.now
      val = yield
      logger.info "Completed #{name} in #{Time.now - start} seconds"
      val
    end

    def actions
      [:browse_loan_requests, :sign_up_as_lender, :user_views_loan_request, :new_user_creates_request, :lender_makes_loan, :browse_pages_of_loan_requests, :browse_categories, :browse_pages_of_categories]
    end

    def browse_loan_requests
      10.times do
        session.visit "#{host}/browse"
        session.within('#pageLinks') do
          session.all('a').sample.click
        end
        session.all(".lr-about").sample.click
      end
    end

    def browse_categories
      10.times do
        session.visit "#{host}/browse"
        session.within('#categories') do
          session.all('a').sample.click
        end
        session.all(".lr-about").sample.click
      end
    end

    def browse_pages_of_categories
      session.visit "#{host}/browse"
      session.within('#categories') do
        session.all('a').sample.click
      end
      10.times do
        session.within('#pageLinks') do
          session.all('a').sample.click
        end
      end
    end

    def browse_pages_of_loan_requests
      log_in
      session.visit "#{host}/browse"
      10.times do
        session.within('#pageLinks') do
          session.all('a').sample.click
        end
      end
    end

    def user_views_loan_request
      log_in
      session.visit "#{host}/browse"
      3.times do
        session.within('#pageLinks') do
          session.all('a').sample.click
        end
      end
      session.all(".lr-about").sample.click
    end

    def lender_makes_loan
      user_views_loan_request
      session.click_on('Contribute $25')
      session.click_on('Basket')
      session.click_on('Transfer Funds')
    end

    def new_user_creates_request(title = new_request_title)
      log_out
      sign_up_as_borrower
      session.click_on "Create Loan Request"
      session.within('#loanRequestModal') do
        session.fill_in('loan_request_title', with: title)
        session.fill_in('loan_request_description', with: new_request_description)
        session.fill_in('loan_request_requested_by_date', with: request_by_date)
        session.fill_in('loan_request_repayment_begin_date', with: repayment_date)
        session.select('Agriculture', from: 'loan_request_category')
        session.fill_in('loan_request_amount', with: '200')
        session.click_on('Submit')
      end
    end

    def sign_up_as_lender(name = new_user_name)
      log_out
      session.find("#sign-up-dropdown").click
      session.find("#sign-up-as-lender").click
      session.within("#lenderSignUpModal") do
        session.fill_in("user_name", with: name)
        session.fill_in("user_email", with: new_user_email(name))
        session.fill_in("user_password", with: "password")
        session.fill_in("user_password_confirmation", with: "password")
        session.click_link_or_button "Create Account"
      end
    end

    def sign_up_as_borrower(name = new_user_name)
      log_out
      session.find("#sign-up-dropdown").click
      session.find("#sign-up-as-borrower").click
      session.within("#borrowerSignUpModal") do
        session.fill_in("user_name", with: name)
        session.fill_in("user_email", with: new_user_email(name))
        session.fill_in("user_password", with: "password")
        session.fill_in("user_password_confirmation", with: "password")
        session.click_link_or_button "Create Account"
      end
    end

    def log_in(email=EMAILS.sample, pw="password")
      log_out
      session.visit host
      session.click_on("Login")
      session.fill_in('session_email', with: email)
      session.fill_in('session_password', with: pw)
      session.click_on("Log In")
    end

    def log_out
      session.visit host
      if session.has_content?("Log out")
        session.find("#logout").click
      end
    end

    def new_user_name
      "#{Faker::Name.name} #{Time.now.to_i}"
    end

    def new_user_email(name)
      "TuringPivotBots+#{name.split.join}@gmail.com"
    end

    def new_request_title
      "#{Faker::Commerce.product_name} #{Time.now.to_i}"
    end

    def new_request_description
      Faker::Company.catch_phrase
    end

    def request_by_date
      Faker::Time.between(7.days.ago, 3.days.ago)
    end

    def repayment_date
      Faker::Time.between(3.days.ago, Time.now)
    end
  end
end
