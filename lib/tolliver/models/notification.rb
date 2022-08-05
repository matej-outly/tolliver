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
        has_many :notification_receivers, class_name: Tolliver.notification_receiver_model.to_s, through: :notification_deliveries
        has_many :notification_attachments, class_name: Tolliver.notification_attachment_model.to_s, dependent: :destroy
        belongs_to :notification_template, class_name: Tolliver.notification_template_model.to_s, optional: true

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
        Tolliver::Services::DeliveryService.instance.deliver(self)
      end

      def enqueue_for_delivery
        Tolliver::Services::DeliveryService.instance.enqueue_for_delivery(self)
      end

      def reset_delivery
        Tolliver::Services::DeliveryService.instance.reset_delivery(self)
      end

    end
  end
end