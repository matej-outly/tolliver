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
            @api = ::Plivo::RestAPI.new(@auth_id, @auth_token)
          end

          def deliver(notification, notification_receiver)

            # Check message length.
            if message.bytesize > 200
              raise 'Message too long.'
            end

            # Request API
            response = @api.send_message({
                                             'src' => Tolliver.sms_sender, # TODO: This should be improved to take sender from number pool and remember number / message mapping
                                             'dst' => notification_receiver.receiver_contact.to_s,
                                             'text' => ActionController::Base.helpers.strip_tags(notification.message.to_s),
                                             'method' => 'POST'
                                         })

            true
          end

        end
      end
    end
  end
end