# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification
# *
# * Author: Matěj Outlý
# * Date  : 21. 1. 2016
# *
# *****************************************************************************

module Tolliver
  module Models
    module Notification
      extend ActiveSupport::Concern

      included do

        # *********************************************************************
        # Structure
        # *********************************************************************

        has_many :notification_deliveries, class_name: Tolliver.notification_delivery_model.to_s, dependent: :destroy
        has_many :notification_attachments, class_name: Tolliver.notification_attachment_model.to_s, dependent: :destroy
        belongs_to :notification_template, class_name: Tolliver.notification_template_model.to_s

        # *********************************************************************
        # Validators
        # *********************************************************************

        validates_presence_of :subject

      end

      # ***********************************************************************
      # Progress
      # ***********************************************************************

      def done
        sent_count = 0
        receivers_count = 0
        self.notification_deliveries.each do |notification_delivery|
          sent_count += notification_delivery.sent_count.to_i
          receivers_count += notification_delivery.receivers_count.to_i
        end
        sent_count.to_s + "/" + receivers_count.to_s
      end

      # ***********************************************************************
      # Service
      # ***********************************************************************

      def deliver
        Tolliver::Services::Delivery.instance.deliver(self)
      end

      def enqueue_for_delivery
        Tolliver::Services::Delivery.instance.enqueue_for_delivery(self)
      end

    end
  end
end