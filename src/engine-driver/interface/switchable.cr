module ACAEngine::Driver::Interface; end

module ACAEngine::Driver::Interface::InputSelection(Input)
  # Switches all outputs to the requested input
  # Special case `switch_to 0` should mute all the outputs, if supported
  abstract def switch_to(input : Input)
end

module ACAEngine::Driver::Interface::Switchable(Input, Output)
  include ACAEngine::Driver::Interface::InputSelection(Input)

  enum SwitchLayer
    Audio
    Video
    Data
    Data2
  end

  macro included
    # { layer => { input => [output1, output2] } }
    alias SelectiveSwitch = Hash(String, Hash(Input, Array(Output)))

    # {input => [output1, output2]}
    alias FullSwitch = Hash(Input, Array(Output))
  end

  abstract def switch(map : Hash(Input, Array(Output)) | Hash(String, Hash(Input, Array(Output))))
end
