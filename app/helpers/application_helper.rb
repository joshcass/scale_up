module ApplicationHelper
  def bootstrap_class_for(flash_type)
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible", role: "alert") do
        concat(content_tag(:button, class: "close", data: { dismiss: "alert" }) do
          concat content_tag(:span, "&times;".html_safe, "aria-hidden" => true)
          concat content_tag(:span, "Close", class: "sr-only")
        end)
        concat message
      end)
    end
    nil
  end
end

# do in javascript or possible contender for a go piece
def loan_request_contributuion(loan_requests_contributors, loan_requst_id)
  loan_requests_contributors.detect{ |l| l.loan_request_id == loan_requst_id }
end
