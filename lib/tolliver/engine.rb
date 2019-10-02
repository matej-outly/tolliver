# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

module Tolliver
	class Engine < ::Rails::Engine

		# Controllers
		require "tolliver/controllers/notifications_controller"
		require "tolliver/controllers/notification_templates_controller"

		isolate_namespace Tolliver
	end
end

