require "lita/adapters/hipchat"
require "hipchat"

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
    class HipChat
      require_configs :api_token

      attr_reader :api_client

      alias_method :initialize_org, :initialize
      def initialize(robot)
        initialize_org robot

        initialize_api
        fill_jid_to_rooms
      end

      def send_messages_with_option(target, strings, option: nil)
        if target.private_message?
          api_user = api_user_of target.user.id
          strings.each do |s|
            api_user.send s # option not supported yet on hipchat-rb
          end
        else
          api_room = api_room_of target.room
          strings.each do |s|
            api_room.send "", s, option
          end
        end
      end

      def refresh
        initialize_api
        fill_jid_to_rooms
      end

      private

      def initialize_api
        @api_client = ::HipChat::Client.new(
          config.api_token,
          api_version: config.api_version || "v2",
          server_url: config.server || "chat.hipchat.com"
        )
      end

      def fill_jid_to_rooms
        api_client.rooms.each do |room|
          room.xmpp_jid = room.get_room['xmpp_jid']
        end
      end

      def api_user_of(jid)
        api_client.users.select do |user|
          user.xmpp_jid == jid
        end.first
      end

      def api_room_of(jid)
        api_client.rooms.select do |room|
          room.xmpp_jid == jid
        end.first
      end
    end

  end
end
