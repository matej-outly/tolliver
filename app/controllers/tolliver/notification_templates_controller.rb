# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification templates
# *
# * Author: Matěj Outlý
# * Date  : 9. 5. 2016
# *
# *****************************************************************************

require_dependency "tolliver/application_controller"

module Tolliver
	class NotificationTemplatesController < ApplicationController
		include Tolliver::Controllers::NotificationTemplatesController
	end
end
