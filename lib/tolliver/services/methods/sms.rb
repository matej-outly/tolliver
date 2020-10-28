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

        def deliver(notification_receiver)
          notification = notification_receiver.notification_delivery.notification

          # Send SMS
          begin
            provider.deliver(notification_receiver.receiver_contact, notification.message.strip_tags)
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
          if @provider.nil?
            provider_class_name = "Tolliver::Services::Methods::Sms::#{Tolliver.sms_provider.to_s.camelize}"
            @provider = provider_class_name.constantize.new(Tolliver.sms_provider_params)
          end
          @provider
        end

      end
    end
  end
end