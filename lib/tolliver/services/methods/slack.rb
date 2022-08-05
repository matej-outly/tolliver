# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification method - Slack
# *
# * Author: Matěj Outlý
# * Date  : 21. 1. 2016
# *
# *****************************************************************************

module Tolliver
  module Services
    module Methods
      class Slack

        def is_notification_valid?(notification)
          return false if notification.message.blank?
          true
        end

        def is_notification_delivery_valid?(_)
          true
        end

        def is_notification_receiver_valid?(notification_receiver)
          return false if notification_receiver.receiver_slack_id.blank? && notification_receiver.receiver_email.blank?
          true
        end

        def deliver(notification_receiver)

          # Prepare notification
          notification = notification_receiver.notification_delivery.notification

          # Send message
          begin
            ensure_slack_id(notification_receiver)
            client.chat_postMessage(channel: notification_receiver.receiver_slack_id, text: notification.message)
            notification_receiver.status = 'sent'
          rescue StandardError => e
            notification_receiver.status = 'error'
            notification_receiver.error_message = e.message
          end

          # Mark as sent
          notification_receiver.sent_at = Time.current

          # Save
          notification_receiver.save

          true
        end

        private

        def ensure_slack_id(notification_receiver)
          if notification_receiver.receiver_slack_id.blank?
            unless notification_receiver.receiver_email.blank?
              response = client.users_lookupByEmail(email: notification_receiver.receiver_email)
              if response.ok
                notification_receiver.receiver_slack_id = response.user.id
                notification_receiver.save(validate: false)
              end
            end
          end
          if notification_receiver.receiver_slack_id.blank?
            raise Tolliver::Errors::StandardError.new('Receiver Slack ID not recognized.')
          end
        end

        def client
          if @client.nil?
            require 'slack'
            api_token = Tolliver.slack_params[:api_token]
            if api_token.blank?
              raise Tolliver::Errors::StandardError.new('Please provide API Token in Slack params.')
            end
            ::Slack.configure do |config|
              config.token = api_token
            end
            @client = ::Slack::Web::Client.new
          end
          @client
        end

      end
    end
  end
end