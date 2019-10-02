# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification template
# *
# * Author: Matěj Outlý
# * Date  : 9. 5. 2016
# *
# *****************************************************************************

module Tolliver
	module Models
		module NotificationTemplate extend ActiveSupport::Concern

			included do

				# *************************************************************
				# Structure
				# *************************************************************

				has_many :notification_templates, class_name: Tolliver.notification_template_model.to_s, dependent: :nullify

				# *************************************************************
				# Validators
				# *************************************************************

				validates_presence_of :ref

			end

			module ClassMethods

				def permitted_columns
					[
						:subject,
						:message,
						:disabled,
						:dry
					]
				end

			end

		end
	end
end