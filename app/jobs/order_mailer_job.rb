class OrderMailerJob
  @queue = :order_mailer

  def self.perform(order_id)
    order = Order.find(order_id)
    order.send_contributed_to_email
  end
end
