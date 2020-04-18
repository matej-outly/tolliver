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

      def notify(notification, receiver)

        # Sender
        @sender = Tolliver.mailer_sender
        raise "Please specify sender." if @sender.nil?
        if !Tolliver.mailer_sender_name.blank?
          @sender = "#{Tolliver.mailer_sender_name} <#{@sender}>"
        end

        # Other view data
        @notification = notification
        @receiver = receiver

        # Subject
        subject = !@notification.subject.blank? ? @notification.subject : I18n.t("activerecord.mailers.tolliver.notification.notify.default_subject", url: main_app.root_url)

        # Attachment
        if !notification.attachment.blank?
          attachments[File.basename(notification.attachment)] = File.read(notification.attachment)
        end

        # Mail
        mail(from: @sender, to: receiver.email, subject: subject)
      end

    end
  end
end
