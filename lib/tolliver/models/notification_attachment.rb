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

    end
  end
end