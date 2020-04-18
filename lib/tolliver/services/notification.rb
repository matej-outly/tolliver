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

module Tolliver
  module Services
    module Notification
      extend ActiveSupport::Concern

      module ClassMethods

        def notify(content, receivers, options = {})

          # Object
          notification = Tolliver.notification_model.new

          Tolliver.notification_model.transaction do

            # Get subject, message and params
            subject, message, params, notification_template = parse_content(content)

            if !message.blank?

              # Interpret params and store it in DB
              notification.message = interpret_params(message, params)
              notification.subject = interpret_params(subject, params)

              # Notification template
              notification.notification_template = notification_template

              # Kind
              if options[:kind]
                notification.kind = options[:kind]
              end

              # Sender
              if options[:sender]
                notification.sender = options[:sender]
              end

              # URL
              if options[:url]
                notification.url = options[:url]
              end

              # Attachment
              if options[:attachment]
                notification.attachment = options[:attachment]
              end

              # Signature
              if !options[:signature].blank?
                notification.message += options[:signature].to_s
              end

              # Save to DB
              notification.save

              if !notification_template || notification_template.dry != true

                # Delivery kinds
                if options[:delivery_kinds] # Select only wanted delivery kinds, but valid according to module config
                  delivery_kinds = options[:delivery_kinds]
                  delivery_kinds = delivery_kinds.delete_if { |delivery_kind| !Tolliver.delivery_kinds.include?(delivery_kind.to_sym) }
                else
                  delivery_kinds = Tolliver.delivery_kinds
                end

                # Get valid receivers
                receivers = parse_receivers(receivers)

                delivery_kinds.each do |delivery_kind|

                  # Delivery object
                  notification_delivery = notification.notification_deliveries.create(kind: delivery_kind)

                  # Filter out receivers not valid for this delivery kind
                  if delivery_kind == :email
                    filtered_receivers = receivers.delete_if { |receiver| !receiver.respond_to?(:email) }
                  elsif delivery_kind == :sms
                    filtered_receivers = receivers.delete_if { |receiver| !receiver.respond_to?(:phone) }
                  else
                    filtered_receivers = receivers.dup
                  end

                  # Save to DB
                  filtered_receivers.each do |receiver|
                    notification_delivery.notification_receivers.create(receiver: receiver)
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
          notification.enqueue_for_delivery if !notification.nil?

          return notification
        end

        def parse_content(content)

          # Arrayize
          if !content.is_a?(Array)
            content = [content]
          end

          # Check for empty
          if content.length == 0
            raise "Notification is incorrectly defined."
          end

          # Extract content definition and params
          content_def = content.shift

          # Preset
          params = content
          subject = nil
          message = nil
          notification_template = nil

          if content_def.is_a?(Symbol)

            notification_template = Tolliver.notification_template_model.where(ref: content_def.to_s).first
            if notification_template.nil?
              raise "Notification template #{content_def.to_s} not found."
            end
            if notification_template.disabled != true
              message = notification_template.message
              subject = notification_template.subject
            end

          elsif content_def.is_a?(Hash) # Defined by hash containing subject and message

            subject = content_def[:subject]
            message = content_def[:message]

          elsif content_def.is_a?(String)

            message = content_def

          else
            raise "Notification is incorrectly defined."
          end

          # First parameter is message (all other parameters are indexed from 1)
          params.unshift(message)

          return [subject, message, params, notification_template]
        end

        def parse_receivers(receivers)

          # Arrayize
          if !receivers.is_a?(Array)
            receivers = [receivers]
          end

          # Automatic receivers defined by string
          new_receivers = []
          receivers.each do |receiver|
            if receiver.is_a?(String) || receiver.is_a?(Symbol)
              if Tolliver.people_selector_model && Tolliver.people_selector_model.respond_to?(:decode_value) && Tolliver.people_selector_model.respond_to?(:people)
                ref, params = Tolliver.people_selector_model.decode_value(receiver.to_s)
                new_receivers.concat(Tolliver.people_selector_model.people(ref, params).to_a) # Use people selector to generate receivers
              end
            else
              new_receivers << receiver
            end
          end
          receivers = new_receivers

          # Receivers responding to email or users
          new_receivers = []
          receivers.each do |receiver|
            if receiver.respond_to?(:email)
              new_receivers << receiver
            else
              if receiver.respond_to?(:user)
                new_receivers << receiver.user
              else
                if receiver.respond_to?(:users)
                  new_receivers.concat(receiver.users.to_a)
                end
              end
            end
          end
          receivers = new_receivers

          return receivers
        end

        #
        # Interpret params into given text
        #
        def interpret_params(text, params)
          return text.gsub(/%{[^{}]+}/) do |match|

            # Substitude all %1, %2, %3, ... to a form which can be evaluated
            template_to_eval = match[2..-2].gsub(/%([0-9]+)/, "params[\\1]")

            # Evaluate match
            begin
              evaluated_match = eval(template_to_eval)
            rescue
              evaluated_match = ""
            end

            # Result
            evaluated_match
          end
        end

      end

    end
  end
end