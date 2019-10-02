# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Routes
# *
# * Author: Matěj Outlý
# * Date  : 26. 11. 2015
# *
# *****************************************************************************

Tolliver::Engine.routes.draw do

	# Notifications
	resources :notifications, only: [:index, :show, :destroy] do
		member do
			put :deliver
		end
	end

	# Notification templates
	resources :notification_templates, only: [:index, :edit, :update] do
		member do
			put :disable
			put :enable
			put :dry
			put :undry
		end
	end

end
