module EngineDriver::Interface; end

# Compatible drivers will expose a status variable:
# self[:power] = true / false
# The power state function allows one to sepecify a preferred level of off if
# supported by the device
module EngineDriver::Interface::Powerable
  abstract def power(state : Bool)

  enum PowerState
    On
    Off
    FullOff
  end

  def power_state(state : PowerState)
    case state
    when PowerState::On
      power true
    when PowerState::Off, PowerState::FullOff
      power false
    end
  end
end
