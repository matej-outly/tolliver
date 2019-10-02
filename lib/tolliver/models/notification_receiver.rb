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
		module NotificationReceiver extend ActiveSupport::Concern

			included do

				# *************************************************************
				# Structure
				# *************************************************************

				belongs_to :notification_delivery, class_name: Tolliver.notification_delivery_model.to_s
				belongs_to :receiver, polymorphic: true

				# *************************************************************
				# Validators
				# *************************************************************

				validates_presence_of :notification_delivery_id, :receiver_id, :receiver_type

			end

			# *****************************************************************
			# Receiver
			# *****************************************************************

			# Get name or email in case name is not set
			def receiver_name_or_email
				if self.receiver
					if self.receiver.respond_to?(:name_formatted) && !self.receiver.name_formatted.blank?
						return self.receiver.name_formatted
					elsif self.receiver.respond_to?(:name) && !self.receiver.name.blank?
						return self.receiver.name
					else
						return self.receiver.email
					end
				else
					return nil
				end
			end

			# *****************************************************************
			# Delivery
			# *****************************************************************

			# Deliver notification by correct delivery kind
			def deliver
				return self.send("deliver_by_#{self.notification_delivery.kind}")
			end

		end
	end
end