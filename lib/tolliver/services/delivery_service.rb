# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Common delivery service
# *
# * Author: Matěj Outlý
# * Date  : 19. 4. 2017
# *
# *****************************************************************************

require 'singleton'

module Tolliver
  module Services
    class DeliveryService
      include Singleton

      def enqueue_for_delivery(notification)
        return nil if notification.nil?
        Tolliver::Jobs::DeliveryJob.perform_later(notification.id)
      end

      # Deliver notification to receivers by all configured methods
      def deliver(notification)
        return nil if notification.nil?

        # Load balancing
        unless Tolliver.load_balance.blank?
          notifications_sent_in_protected_time_window = Tolliver.notification_model
                                                            .joins(:notification_deliveries)
                                                            .where.not(id: notification.id)
                                                            .where("notification_deliveries.sent_at > ?", Time.current - Tolliver.load_balance.minutes).distinct
          if notifications_sent_in_protected_time_window.count > 0

            # Sleep for given amount of time
            sleep(Tolliver.load_balance * 60) # seconds

            # Then try again
            enqueue_for_delivery(notification)

            return false
          end
        end

        # Process all notification deliveries
        notification.notification_deliveries.each do |notification_delivery|
          notification_delivery.policy_service.deliver(notification_delivery)
        end

        true
      end

      def reset_delivery(notification)
        return nil if notification.nil?
        notification.notification_deliveries.update_all(sent_count: 0, sent_at: nil)
        notification.notification_receivers.update_all(sent_at: nil, received_at: nil, status: :created, error_message: nil)
        true
      end

    end
  end
end