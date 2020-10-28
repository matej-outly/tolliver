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
      class Batch

        def deliver(notification_delivery, batch_size = 10)

          # Input validation
          return nil if notification_delivery.nil? || notification_delivery.policy != :batch

          # Enqueue in QC
          QC.enqueue("#{self.class.to_s}.deliver", notification_delivery.id, batch_size)
        end

        # Entry point for QC
        def self.deliver(notification_delivery_id, batch_size = 10)

          # Instantiate notification delivery object
          notification_delivery = Tolliver.notification_delivery_model.find_by_id(notification_delivery_id)
          return nil if notification_delivery.nil? || notification_delivery.policy != :batch

          # Call internal logic
          policy_service = self.new
          policy_service.send(:deliver_batch_and_enqueue, notification_delivery, batch_size)
        end

        protected

        def deliver_batch_and_enqueue(notification_delivery, batch_size = 10)

          # Send single batch
          remaining = deliver_batch(notification_delivery, batch_size)

          # If still some receivers remaining, enqueue next batch
          if remaining > 0

            # Sleep for a while to prevent SMTP/SMS service overflow
            sleep 5 # seconds

            # Queue next batch
            deliver(notification_delivery, batch_size)
            false
          else
            true
          end

        end

        def deliver_batch(notification_delivery, batch_size = 10)

          # Nothing to do
          return 0 if notification_delivery.sent_count == notification_delivery.receivers_count

          # Get batch of receivers prepared for send
          notification_receivers = notification_delivery.notification_receivers.where(sent_at: nil).limit(batch_size)

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
