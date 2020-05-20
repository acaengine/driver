require "./subscription"

class PlaceOS::Driver::Subscriptions::DirectSubscription < PlaceOS::Driver::Subscriptions::Subscription
  def initialize(@module_id : String, @status : String, &@callback : (DirectSubscription, String) ->)
    @storage = PlaceOS::Driver::Storage.new(@module_id)
  end

  def callback(logger : ::Log, message : String) : Nil
    # Error handling is the responsibility of the callback
    # This is fine as this should only be used internally
    @callback.call(self, message)
  rescue e
    logger.error(exception: e) { "error in subscription callback" }
  end

  getter :module_id, :status

  def subscribe_to : String?
    "#{@storage.hash_key}/#{@status}"
  end

  def current_value : String?
    @storage[@status]?
  end
end
