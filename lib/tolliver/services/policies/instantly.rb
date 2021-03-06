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
    module Policies
      class Instantly

        def deliver(notification_delivery)

          # Input validation
          return nil if notification_delivery.nil? || notification_delivery.policy != :instantly

          # Nothing to do
          return 0 if notification_delivery.sent_count == notification_delivery.receivers_count

          # Get batch of receivers prepared for send
          notification_receivers = notification_delivery.notification_receivers #.where(sent_at: nil)

          # Send entire batch
          sent_counter = 0
          notification_receivers.each do |notification_receiver|
            sent_counter += 1 if notification_delivery.method_service.deliver(notification_receiver)
          end

          # Is postponed
          notification_delivery.is_postponed = false

          # Update statistics
          notification_delivery.sent_count += sent_counter
          notification_delivery.sent_at = Time.current if notification_delivery.sent_count == notification_delivery.receivers_count

          # Save
          notification_delivery.save

          (notification_delivery.receivers_count - notification_delivery.sent_count)
        end

      end
    end
  end
end