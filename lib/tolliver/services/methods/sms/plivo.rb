# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Plivo SMS provider
# *
# * Author: Matěj Outlý
# * Date  : 1. 12. 2017
# *
# *****************************************************************************

module Tolliver
  module Services
    module Methods
      class Sms
        class Plivo

          def initialize(params = {})
            require 'plivo'
            if params[:auth_id].blank? || params[:auth_token].blank?
              raise Tolliver::Errors::StandardError.new('Please provide Auth ID and Auth Token in SMS provider params.')
            end
            @auth_id = params[:auth_id]
            @auth_token = params[:auth_token]
            @client = ::Plivo::RestClient.new(@auth_id, @auth_token)
          end

          def deliver(notification, notification_receiver)

            # Sender
            raise Tolliver::Errors::StandardError.new("Please specify SMS sender.") if Tolliver.sms_sender.nil?

            # Request API
            @client.message.create(Tolliver.sms_sender, # TODO: This should be improved to take sender from number pool and remember number / message mapping
                                   [notification_receiver.receiver_phone.to_s],
                                   ActionController::Base.helpers.strip_tags(notification.short_message.to_s))

            true
          end

        end
      end
    end
  end
end