require "lita/adapters/hipchat"

# we need to extend Lita core
class ::Lita::Message
  def reply(*strings, option: nil)
    @robot.send_messages(source, *strings, option: option)
  end

  def reply_privately(*strings, option: nil)
    private_source = source.clone
    private_source.private_message!
    @robot.send_messages(private_source, *strings, option: option)
  end

  def reply_with_mention(*strings, option: nil)
    @robot.send_messages_with_mention(source, *strings, option: option)
  end
end

class ::Lita::Robot
  def send_messages(target, *strings, option: nil)
    if @adapter.respond_to? :send_messages_with_option
      @adapter.send_messages_with_option(target, strings.flatten, option: option)
    else
      @adapter.send_messages(target, strings.flatten)
    end
  end
  alias_method :send_message, :send_messages

  def send_messages_with_mention(target, *strings, option: nil)
    return send_messages(target, *strings, option: option) if target.private_message?

    mention_name = target.user.mention_name
    prefixed_strings = strings.map do |s|
      "#{@adapter.mention_format(mention_name).strip} #{s}"
    end

    send_messages(target, *prefixed_strings, option: option)
  end
  alias_method :send_message_with_mention, :send_messages_with_mention
end

module Lita
  module Adapters
    class HipchatApisend < ::Lita::Adapters::HipChat
    end

    Lita.register_adapter(:hipchat_apisend, HipchatApisend)
  end
end
