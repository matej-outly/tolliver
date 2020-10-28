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
require "tolliver/models/notification_attachment"
require "tolliver/models/notification_delivery"
require "tolliver/models/notification_receiver"
require "tolliver/models/notification_template"

# Services
require "tolliver/services/notification"
require "tolliver/services/delivery"
require "tolliver/services/policies/batch"
require "tolliver/services/policies/instantly"
require "tolliver/services/methods/email"
require "tolliver/services/methods/sms"

# Mailers
require "tolliver/mailers/notification_mailer"

# Utils
require "tolliver/utils/enum"

# Errors
require "tolliver/errors/standard_error"
require "tolliver/errors/bad_request"
require "tolliver/errors/not_found"

module Tolliver

  # This will keep Rails Engine from generating all table prefixes with the engines name
  def self.table_name_prefix
  end

  # *************************************************************************
  # Services
  # *************************************************************************

  def self.notify(options)
    Tolliver::Services::Notification.instance.notify(options)
  end

  def self.deliver(notification)
    Tolliver::Services::Delivery.instance.deliver(notification)
  end

  def self.enqueue_for_delivery(notification)
    Tolliver::Services::Delivery.instance.enqueue_for_delivery(notification)
  end

  def self.reset_delivery(notification)
    Tolliver::Services::Delivery.instance.reset_delivery(notification)
  end

  # *************************************************************************
  # Configuration
  # *************************************************************************

  # Default way to setup module
  def self.setup
    yield self
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

  # Notification attachment model
  mattr_accessor :notification_attachment_model

  def self.notification_attachment_model
    return @@notification_attachment_model.constantize
  end

  @@notification_attachment_model = "Tolliver::NotificationAttachment"

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

  # Delivery methods
  #
  # Available methods:
  # - email
  # - sms
  # - whatever
  mattr_accessor :delivery_methods
  @@delivery_methods = [
      :email
  ]

  # Load balancer defined in minutes
  #
  # If another notification have been delivered in last X minutes, delivery
  # will be postponed. It should prevent delivery service overloading in case
  # of some mistake or security problem.
  mattr_accessor :load_balance
  @@load_balance = nil

  # E-mail sender
  mattr_accessor :email_sender
  #@@email_sender = "test@domain.com" to be set in module initializer if needed

  # E-mail sender name
  mattr_accessor :email_sender_name
  #@@email_sender_name = "Test sender" to be set in module initializer if needed

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
