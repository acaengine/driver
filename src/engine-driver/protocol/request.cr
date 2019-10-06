require "../exception"

abstract class EngineDriver; end

class EngineDriver::Protocol; end

class EngineDriver::Protocol::Request
  include JSON::Serializable

  def initialize(@id, @cmd, @payload = nil, @error = nil, @backtrace = nil, @seq = nil, @reply = nil)
  end

  property id : String
  property cmd : String

  # Used to track request and responses
  property seq : UInt64?

  # For driver to driver comms to route the request back to the originating module
  property reply : String?

  property payload : String?
  property error : String?
  property backtrace : Array(String)?

  def set_error(error)
    self.payload = error.message
    self.error = error.class.to_s
    self.backtrace = error.backtrace?
    self
  end

  def build_error
    EngineDriver::RemoteException.new(self.payload, self.error, self.backtrace || [] of String)
  end

  # Not part of the JSON payload, so we don't need to re-parse a request
  @[JSON::Field(ignore: true)]
  property driver_model : ::EngineDriver::DriverModel? = nil
end
