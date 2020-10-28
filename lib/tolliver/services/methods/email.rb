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
          notification = notification_receiver.notification_delivery.notification

          # Send email
          begin
            Tolliver::NotificationMailer.notify(notification, notification_receiver).deliver_now
            notification_receiver.state = 'sent'
          #rescue Net::SMTPFatalError, Net::SMTPSyntaxError
          rescue StandardError => e
            notification_receiver.state = 'error'
            notification_receiver.error_message = e.message
          end

          # Mark as sent
          notification_receiver.sent_at = Time.current

          # Save
          notification_receiver.save

          true
        end

      end
    end
  end
end