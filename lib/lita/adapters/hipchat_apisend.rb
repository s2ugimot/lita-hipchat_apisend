module Lita
  module Adapters
    class HipchatApisend < Adapter
    end

    Lita.register_adapter(:hipchat_apisend, HipchatApisend)
  end
end
