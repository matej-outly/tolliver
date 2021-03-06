# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification attachment
# *
# * Author: Matěj Outlý
# * Date  : 27. 10. 2020
# *
# *****************************************************************************

module Tolliver
  module Models
    module NotificationAttachment
      extend ActiveSupport::Concern

      included do

        # *********************************************************************
        # Structure
        # *********************************************************************

        belongs_to :notification, class_name: Tolliver.notification_model.to_s

        # *********************************************************************
        # Validators
        # *********************************************************************

        validates_presence_of :notification_id

      end

      def read
        if @data.nil?
          unless self.attachment.blank?
            @data = Base64.strict_decode64(self.attachment) rescue nil
          end
          unless self.url.blank?
            @data = open(self.url) { |f| f.read }
          end
        end
        @data
      end

    end
  end
end