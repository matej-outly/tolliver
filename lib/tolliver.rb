# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Tolliver engine
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

# Engine
require "tolliver/engine"

# Models
require "tolliver/models/notification"
require "tolliver/models/notification_delivery"
require "tolliver/models/notification_delivery/batch"
require "tolliver/models/notification_delivery/instantly"
require "tolliver/models/notification_receiver"
require "tolliver/models/notification_receiver/email"
require "tolliver/models/notification_receiver/mailboxer"
require "tolliver/models/notification_receiver/sms"
require "tolliver/models/notification_template"

# Services
require "tolliver/services/notification"
require "tolliver/services/delivery"

# Mailers
require "tolliver/mailers/notification_mailer"

module Tolliver

	# This will keep Rails Engine from generating all table prefixes with the engines name
	def self.table_name_prefix
	end

	# *************************************************************************
	# Services
	# *************************************************************************

	include Tolliver::Services::Notification
	include Tolliver::Services::Delivery

	# *************************************************************************
	# Configuration
	# *************************************************************************

	# Default way to setup module
	def self.setup
		yield self
	end

	# *************************************************************************
	# SMS
	# *************************************************************************

	def self.sms_provider_obj
		if @sms_provider_obj.nil?
			sms_provider_class_name = "Tolliver::Services::Sms::#{Tolliver.sms_provider.to_s.to_camel}"
			@sms_provider_obj = sms_provider_class_name.constantize.new(Tolliver.sms_provider_params)
		end
		return @sms_provider_obj
	end

	# *************************************************************************
	# Config options
	# *************************************************************************

	# Notification model
	mattr_accessor :notification_model
	def self.notification_model
		return @@notification_model.constantize
	end
	@@notification_model = "Tolliver::Notification"

	# Notification delivery model
	mattr_accessor :notification_delivery_model
	def self.notification_delivery_model
		return @@notification_delivery_model.constantize
	end
	@@notification_delivery_model = "Tolliver::NotificationDelivery"

	# Notification receiver model
	mattr_accessor :notification_receiver_model
	def self.notification_receiver_model
		return @@notification_receiver_model.constantize
	end
	@@notification_receiver_model = "Tolliver::NotificationReceiver"

	# Notification template model
	mattr_accessor :notification_template_model
	def self.notification_template_model
		return @@notification_template_model.constantize
	end
	@@notification_template_model = "Tolliver::NotificationTemplate"

	# Available notification template refs. For each defined ref there will be
	# an automatically created record in the notification_templates table.
	# System administrator can define content of this template via admin
	# interface.
	mattr_accessor :template_refs
	@@template_refs = [
#		:some_notification_ref_1,
#		:some_notification_ref_2,
	]

	# Delivery kinds
	#
	# Available kinds:
	# - email
	# - sms
	# - whatever
	mattr_accessor :delivery_kinds
	@@delivery_kinds = [
		:email
	]

	# Load balancer defined in minutes
	#
	# If another notification have been delivered in last X minutes, delivery
	# will be postponed. It should prevent delivery service overloading in case
	# of some mistake or security problem.
	mattr_accessor :load_balance
	@@load_balance = nil

	# Mailer sender
	mattr_accessor :mailer_sender
	#@@mailer_sender = "test@domain.com" to be set in module initializer if needed

	# Mailer sender name
	mattr_accessor :mailer_sender_name
	#@@mailer_sender_name = "Test sender" to be set in module initializer if needed

	# Used SMS provider
	mattr_accessor :sms_provider
	@@sms_provider = :plivo

	# SMS provider params
	mattr_accessor :sms_provider_params
	@@sms_provider_params = {}

	# Used SMS provider
	mattr_accessor :sms_sender
	#@@sms_sender = "+420 123 456 789" to be set in module initializer if needed

end
