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
		module Notification extend ActiveSupport::Concern

			included do

				# *************************************************************
				# Structure
				# *************************************************************

				has_many :notification_deliveries, class_name: RicNotification.notification_delivery_model.to_s, dependent: :destroy
				belongs_to :sender, polymorphic: true
				belongs_to :notification_template, class_name: RicNotification.notification_template_model.to_s

			end

			# *****************************************************************
			# Progress
			# *****************************************************************

			def done
				sent_count = 0
				receivers_count = 0
				self.notification_deliveries.each do |notification_delivery|
					sent_count += notification_delivery.sent_count.to_i
					receivers_count += notification_delivery.receivers_count.to_i
				end
				return sent_count.to_s + "/" + receivers_count.to_s
			end

			# *****************************************************************
			# Sender
			# *****************************************************************

			# Get name or email in case name is not set
			def sender_name_or_email
				if self.sender
					if self.sender.respond_to?(:name_formatted) && !self.sender.name_formatted.blank?
						return self.sender.name_formatted
					elsif self.sender.respond_to?(:name) && !self.sender.name.blank?
						return self.sender.name
					else
						return self.sender.email
					end
				else
					return nil
				end
			end

			# *****************************************************************
			# Delivery
			# *****************************************************************

			# Enqueue for delivery
			def enqueue_for_delivery
				QC.enqueue("#{self.class.to_s}.deliver", self.id)
			end

			# Deliver notification to receivers by all configured methods
			def deliver
				self.notification_deliveries.each do |notification_delivery|
					notification_delivery.deliver
				end
			end

			module ClassMethods

				# Deliver notification (defined by ID) to receivers by all configured methods
				def deliver(notification_id)

					# Find notification object
					notification = Tolliver.notification_model.find_by_id(notification_id)
					return nil if notification.nil?

					# Load balance
					if !Tolliver.load_balance.blank?
						notifications_sent_in_protected_time_window = Tolliver.notification_model
							.joins(:notification_deliveries)
							.where.not(id: notification.id)
							.where("notification_deliveries.sent_at > ?", Time.current - Tolliver.load_balance.minutes).distinct
						if notifications_sent_in_protected_time_window.count > 0

							# Sleep for given amount of time
							sleep (Tolliver.load_balance * 60) # seconds

							# Then try again
							notification.enqueue_for_delivery

							return notification
						end
					end

					# Deliver
					notification.deliver

					return notification
				end

			end

		end
	end
end