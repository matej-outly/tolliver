# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification mailer
# *
# * Author: Matěj Outlý
# * Date  : 21. 1. 2016
# *
# *****************************************************************************

module Tolliver
  module Mailers
    module NotificationMailer
      extend ActiveSupport::Concern

      def notify(notification, notification_receiver)

        # Sender
        @sender_email = Tolliver.email_sender
        raise Tolliver::Errors::StandardError.new("Please specify e-mail sender.") if @sender_email.nil?
        unless Tolliver.email_sender_name.blank?
          @sender_email = "#{Tolliver.email_sender_name} <#{@sender_email}>"
        end

        # Other view data
        @notification = notification
        @notification_receiver = notification_receiver

        # Attachments
        notification.notification_attachments.each do |notification_attachment|
          attachments[notification_attachment.name] = notification_attachment.attachment
        end

        # Mail
        mail(from: @sender_email, to: @notification_receiver.receiver_contact.to_s, subject: @notification.subject)
      end

    end
  end
end
