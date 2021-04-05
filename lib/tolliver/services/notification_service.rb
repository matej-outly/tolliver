# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification service
# *
# * Author: Matěj Outlý
# * Date  : 19. 4. 2017
# *
# *****************************************************************************

require 'singleton'

module Tolliver
  module Services
    class NotificationService
      include Singleton

      def notify(options)
        options = options.deep_symbolize_keys

        # Object
        notification = Tolliver.notification_model.new

        Tolliver.notification_model.transaction do

          # Get notification template object
          template = options[:template]
          raise Tolliver::Errors::BadRequest.new('Missing template.') if template.blank?
          notification_template = Tolliver.notification_template_model.where(ref: template).first
          notification_template = Tolliver.notification_template_model.where(id: template).first if notification_template.nil?
          raise Tolliver::Errors::NotFound.new("Template #{template.to_s} not found.") if notification_template.nil?

          if !notification_template.is_disabled && !notification_template.message.blank?

            # Interpret params and store it in DB
            params = map_params(options[:params] || {})
            notification.message = eval_expressions(interpret_named_params(notification_template.message, params))
            notification.subject = eval_expressions(interpret_named_params(notification_template.subject, params))

            # Notification template
            notification.notification_template = notification_template

            # Signature
            unless options[:signature].blank?
              notification.message += options[:signature].to_s
            end

            # Save to DB
            notification.save

            # Attachments
            unless options[:attachments].blank?
              attachments = options[:attachments]
              attachments = [attachments] unless attachments.is_a?(Array)
              attachments.each do |attachment|
                raise Tolliver::Errors::BadRequest.new('Missing attachment name.') if attachment[:name].blank?
                raise Tolliver::Errors::BadRequest.new('Missing attachment data.') if attachment[:attachment].blank?
                notification.notification_attachments.create(name: attachment[:name], attachment: attachment[:attachment])
              end
            end

            unless notification_template.is_dry

              # Delivery methods
              if options[:methods].blank?
                methods = Tolliver.delivery_methods
              else
                # Select only wanted delivery methods, but valid according to module config
                methods = options[:methods]
                methods = [methods] unless methods.is_a?(Array)
                methods = methods.delete_if { |method| !Tolliver.delivery_methods.include?(method.to_sym) }
              end

              methods.each do |method|

                # Delivery object
                notification_delivery = notification.notification_deliveries.create(method: method)

                # Is postponed
                if options[:is_postponed]
                  notification_delivery.is_postponed = options[:is_postponed]
                end

                # Sender
                unless options[:sender].blank?
                  raise Tolliver::Errors::BadRequest.new('Missing sender ref.') if options[:sender][:ref].blank?
                  raise Tolliver::Errors::BadRequest.new('Missing sender contact.') if options[:sender][:contact].blank?
                  notification_delivery.sender_ref = options[:sender][:ref]
                  notification_delivery.sender_contact = options[:sender][:contact]
                end

                # Receivers
                receivers = options[:receivers] || []
                raise Tolliver::Errors::BadRequest.new('Missing receivers.') if receivers.blank? || receivers.empty?
                receivers = [receivers] unless receivers.is_a?(Array)
                filtered_receivers = receivers.dup # TODO contact validation based on method and filter

                # Save to DB
                filtered_receivers.each do |receiver|
                  raise Tolliver::Errors::BadRequest.new('Missing receiver ref.') if receiver[:ref].blank?
                  raise Tolliver::Errors::BadRequest.new('Missing receiver contact.') if receiver[:contact].blank?
                  notification_delivery.notification_receivers.create(receiver_ref: receiver[:ref], receiver_contact: receiver[:contact])
                end
                notification_delivery.sent_count = 0
                notification_delivery.receivers_count = filtered_receivers.size
                notification_delivery.save

              end

            end

          else
            notification = nil # Do not create notification with empty message
          end

        end

        # Enqueue for delivery
        if !notification.nil? && !options[:is_postponed]
          notification.enqueue_for_delivery
        end

        notification
      end

      protected

      def map_params(params)
        result = {}
        params.each do |param|
          raise Tolliver::Errors::BadRequest.new('Missing param key.') if param[:key].blank?
          raise Tolliver::Errors::BadRequest.new('Missing param value.') if param[:value].nil?
          result[param[:key].to_s] = param[:value]
        end
        result
      end

      def interpret_named_params(text, params)
        text.gsub(/%{[^{}]+}/) do |match|
          key = match[2..-2].to_s.strip
          if params.has_key?(key)
            params[key] # return param value if key found
          else
            match # return entire match if key not found
          end
        end
      end

      def eval_expressions(text)
        text.gsub(/%{[^{}]+}/) do |match|
          template_to_eval = match[2..-2].to_s.strip
          begin
            evaluated_match = eval(template_to_eval) # evaluate match
          rescue
            evaluated_match = ""
          end
          evaluated_match
        end
      end

      def interpret_positional_params_and_eval_expressions(text, params)
        text.gsub(/%{[^{}]+}/) do |match|
          template_to_eval = match[2..-2].gsub(/%([0-9]+)/, "params[\\1]") # substitute all %1, %2, %3, ... to a form which can be evaluated
          begin
            evaluated_match = eval(template_to_eval) # evaluate match against params
          rescue
            evaluated_match = ""
          end
          evaluated_match
        end
      end

    end

  end
end
