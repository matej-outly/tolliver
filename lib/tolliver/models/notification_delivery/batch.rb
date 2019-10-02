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
	module Models
		module NotificationDelivery
			module Batch extend ActiveSupport::Concern

				module ClassMethods

				protected

					def deliver_batch(notification_delivery_id, batch_size = 10)

						# Find notification delivery object
						notification_delivery = Tolliver.notification_delivery_model.find_by_id(notification_delivery_id)
						return nil if notification_delivery.nil? || notification_delivery.policy != :batch

						# Nothing to do
						return 0 if notification_delivery.sent_count == notification_delivery.receivers_count

						# Get batch of receivers prepared for send
						notification_receivers = notification_delivery.notification_receivers.where(sent_at: nil).limit(batch_size)

						# Send entire batch
						sent_counter = 0
						notification_receivers.each do |notification_receiver|
							sent_counter += 1 if notification_receiver.deliver
						end

						# Update statistics
						notification_delivery.sent_count += sent_counter
						notification_delivery.sent_at = Time.current if notification_delivery.sent_count == notification_delivery.receivers_count

						# Save
						notification_delivery.save

						return (notification_delivery.receivers_count - notification_delivery.sent_count)

					end

					def deliver_batch_and_enqueue(notification_delivery_id, batch_size = 10)

						# Send single batch
						remaining = deliver_batch(notification_delivery_id, batch_size)
						return nil if remaining.nil?

						# If still some receivers remaining, enqueue next batch
						if remaining > 0

							# Sleep for a while to prevent SMTP/SMS service overflow
							sleep 5 # seconds

							# Queue next batch
							QC.enqueue("#{self.to_s}.deliver_batch_and_enqueue", notification_delivery_id, batch_size)
							return false
						else
							return true
						end

					end

				end

			end
		end
	end
end