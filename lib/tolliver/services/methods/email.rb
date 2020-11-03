# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification method - E-mail
# *
# * Author: Matěj Outlý
# * Date  : 21. 1. 2016
# *
# *****************************************************************************

module Tolliver
  module Services
    module Methods
      class Email

        def deliver(notification_receiver)
          return false if provider.nil?

          # Prepare notification
          notification = notification_receiver.notification_delivery.notification

          # Send email
          begin
            provider.deliver(notification, notification_receiver)
            notification_receiver.status = 'sent'
          #rescue Net::SMTPFatalError, Net::SMTPSyntaxError
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
          if @provider.nil? && Tolliver.email_provider
            provider_class_name = "Tolliver::Services::Methods::Email::#{Tolliver.email_provider.to_s.camelize}"
            @provider = provider_class_name.constantize.new(Tolliver.email_provider_params)
          end
          @provider
        end

      end
    end
  end
end