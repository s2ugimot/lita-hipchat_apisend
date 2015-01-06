require "lita/adapters/hipchat"
require "hipchat"

module Lita
  module Adapters
    class HipChat

      # Required attributes
      config :api_token, type: String, required: true

      # Optional attributes
      config :api_version, type: String, default: "v2"

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
            api_user.send s, option
          end
        else
          api_room = api_room_of target.room
          strings.each do |s|
            api_room.send "", s, option
          end
        end
      end

      def refresh_api
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
