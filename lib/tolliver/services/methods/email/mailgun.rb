# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Mailgun e-mail provider
# *
# * Author: Matěj Outlý
# * Date  : 1. 12. 2017
# *
# *****************************************************************************

module Tolliver
  module Services
    module Methods
      class Email
        class Mailgun

          def initialize(params = {})
            require 'mailgun-ruby'
            if params[:api_key].blank? || params[:domain].blank?
              raise Tolliver::Errors::StandardError.new('Please provide API key and domain in e-mail provider params.')
            end
            @client = ::Mailgun::Client.new(params[:api_key])
            @domain = params[:domain]
          end

          def deliver(notification, notification_receiver)

            # Sender
            raise Tolliver::Errors::StandardError.new("Please specify e-mail sender.") if Tolliver.email_sender.nil?

            # Message builder
            message = ::Mailgun::MessageBuilder.new
            message.from(Tolliver.email_sender, {'full_name' => Tolliver.email_sender_name})
            message.add_recipient(:to, notification_receiver.receiver_contact.to_s)
            message.reply_to(notification_receiver.notification_delivery.sender_contact.to_s) unless notification_receiver.notification_delivery.sender_contact.blank?
            message.subject(notification.subject)
            message.body_text(ActionController::Base.helpers.strip_tags(notification.message.to_s))
            message.body_html(notification.message)
            notification.notification_attachments.each do |notification_attachment|
              message.add_attachment(StringIO.new(notification_attachment.read), notification_attachment.name) if notification_attachment.read
            end
            response = @client.send_message(@domain, message)
            if response.code != 200
              raise Tolliver::Errors::StandardError.new(response.body)
            end

            true
          end

        end
      end
    end
  end
end
