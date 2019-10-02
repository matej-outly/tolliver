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

module Tolliver
	module Controllers
		module NotificationTemplatesController extend ActiveSupport::Concern

			included do

				before_action :set_notification_template, only: [:edit, :update, :disable, :enable, :dry, :undry]
				before_action :create_missing_notification_templates, only: [:index]
				before_action :save_referrer, only: [:edit]

			end

			# *************************************************************
			# Actions
			# *************************************************************

			def edit
			end

			def index
				@notification_templates = Tolliver.notification_template_model.all.order(ref: :asc)
			end

			def disable
				@notification_template.update(disabled: true)
				respond_to do |format|
					format.html { redirect_to request.referrer, notice: Tolliver.notification_template_model.human_notice_message(:update) }
					format.json { render json: @notification_template.id }
				end
			end

			def enable
				@notification_template.update(disabled: false)
				respond_to do |format|
					format.html { redirect_to request.referrer, notice: Tolliver.notification_template_model.human_notice_message(:update) }
					format.json { render json: @notification_template.id }
				end
			end

			def dry
				@notification_template.update(dry: true)
				respond_to do |format|
					format.html { redirect_to request.referrer, notice: Tolliver.notification_template_model.human_notice_message(:update) }
					format.json { render json: @notification_template.id }
				end
			end

			def undry
				@notification_template.update(dry: false)
				respond_to do |format|
					format.html { redirect_to request.referrer, notice: Tolliver.notification_template_model.human_notice_message(:update) }
					format.json { render json: @notification_template.id }
				end
			end

			def update
				if @notification_template.update(notification_template_params)
					respond_to do |format|
						format.html { redirect_to load_referrer, notice: Tolliver.notification_template_model.human_notice_message(:update) }
						format.json { render json: @notification_template.id }
					end
				else
					respond_to do |format|
						format.html { render "edit" }
						format.json { render json: @notification_template.errors }
					end
				end
			end

		protected

			# *************************************************************
			# Actions
			# *************************************************************

			def create_missing_notification_templates
				if Tolliver.template_refs
					Tolliver.template_refs.each do |ref|
						notification_template = Tolliver.notification_template_model.where(ref: ref).first
						if notification_template.nil?
							notification_template = Tolliver.notification_template_model.create(ref: ref)
						end
					end
				end
			end

			def set_notification_template
				@notification_template = Tolliver.notification_template_model.find_by_id(params[:id])
				not_found if @notification_template.nil?
			end

			# *************************************************************
			# Param filters
			# *************************************************************

			def notification_template_params
				params.require(:notification_template).permit(Tolliver.notification_template_model.permitted_columns)
			end

		end
	end
end

