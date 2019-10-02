# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification receiver
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2017
# *
# *****************************************************************************

module Tolliver
	class NotificationDelivery < ActiveRecord::Base
		include Tolliver::Models::NotificationDelivery
		include Tolliver::Models::NotificationDelivery::Batch
		include Tolliver::Models::NotificationDelivery::Instantly
	end
end