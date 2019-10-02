# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notifications
# *
# * Author: Matěj Outlý
# * Date  : 21. 1. 2016
# *
# *****************************************************************************

require_dependency "tolliver/application_controller"

module Tolliver
	class NotificationsController < ApplicationController
		include Tolliver::Controllers::NotificationsController
	end
end
