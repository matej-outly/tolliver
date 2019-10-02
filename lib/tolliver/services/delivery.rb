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

module Tolliver
	module Services
		module Delivery extend ActiveSupport::Concern

			module ClassMethods

				#
				# Deliver notification (defined by ID) to receivers by all configured methods
				#
				def deliver(notification_id)
					Tolliver.notification_model.deliver(notification_id)
				end

			end

		end
	end
end