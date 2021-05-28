# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification receiver
# *
# * Author: Matěj Outlý
# * Date  : 21. 1. 2016
# *
# *****************************************************************************

module Tolliver
  module Services
    module Methods
      class Sms

        def is_notification_valid?(notification)
          return false if notification.short_message.blank?
          true
        end

        def is_notification_delivery_valid?(_)
          true
        end

        def is_notification_receiver_valid?(notification_receiver)
          return false if notification_receiver.receiver_phone.blank?
          true
        end

        def deliver(notification_receiver)
          return false if provider.nil?

          # Prepare notification
          notification = notification_receiver.notification_delivery.notification

          # Send SMS
          begin
            provider.deliver(notification, notification_receiver)
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

        protected

        def provider
          if @provider.nil? && Tolliver.sms_provider
            provider_class_name = "Tolliver::Services::Methods::Sms::#{Tolliver.sms_provider.to_s.camelize}"
            @provider = provider_class_name.constantize.new(Tolliver.sms_provider_params)
          end
          @provider
        end

      end
    end
  end
end