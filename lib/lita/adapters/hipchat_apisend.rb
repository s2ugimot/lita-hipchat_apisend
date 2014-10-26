require "lita/adapters/hipchat"

module Lita
  module Adapters
    class HipchatApisend < ::Lita::Adapters::HipChat
    end

    Lita.register_adapter(:hipchat_apisend, HipchatApisend)
  end
end
