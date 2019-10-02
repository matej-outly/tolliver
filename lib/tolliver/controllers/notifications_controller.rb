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

module Tolliver
	module Controllers
		module NotificationsController extend ActiveSupport::Concern

			included do

				before_action :set_notification, only: [:show, :deliver, :destroy]

			end

			# *************************************************************
			# Actions
			# *************************************************************

			def index
				@notifications = Tolliver.notification_model.all.order(created_at: :desc).page(params[:page]).per(50)
			end

			def show
			end

			def deliver
				@notification.enqueue_for_delivery
				respond_to do |format|
					format.html { redirect_to request.referrer, notice: Tolliver.notification_model.human_notice_message(:deliver) }
					format.json { render json: @notification.id }
				end
			end

			def destroy
				@notification.destroy
				respond_to do |format|
					format.html { redirect_to request.referrer, notice: Tolliver.notification_model.human_notice_message(:destroy) }
					format.json { render json: @notification.id }
				end
			end

		protected

			# *************************************************************
			# Model setters
			# *************************************************************

			def set_notification
				@notification = Tolliver.notification_model.find_by_id(params[:id])
				not_found if @notification.nil?
			end

		end
	end
end
