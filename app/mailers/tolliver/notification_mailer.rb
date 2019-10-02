# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification mailer
# *
# * Author: Matěj Outlý
# * Date  : 21. 1. 2016
# *
# *****************************************************************************

module Tolliver
	class NotificationMailer < ::ApplicationMailer
		include Tolliver::Mailers::NotificationMailer
	end
end
