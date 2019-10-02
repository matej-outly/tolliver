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
		module NotificationReceiver
			module Sms extend ActiveSupport::Concern

			protected

				# Send notification by SMS
				def deliver_by_sms
					notification = self.notification_delivery.notification

					# Send SMS
					begin
						Tolliver.sms_provider_obj.deliver(self.receiver.phone, notification.message.strip_tags)
						self.state = "sent"
					rescue StandardError => e
						self.state = "error"
						self.error_message = e.message
					end

					# Mark as sent
					self.sent_at = Time.current

					# Save
					self.save

					return true
				end

			end
		end
	end
end