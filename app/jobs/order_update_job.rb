class OrderUpdateJob
  @queue = :order_update

  def self.perform(order_id, user_id)
    order = Order.find(order_id)
    user = User.find(user_id)
    order.update_contributed(user)
  end
end
