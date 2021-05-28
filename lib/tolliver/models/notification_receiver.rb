# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification receiver
# *
# * Author: Matěj Outlý
# * Date  : 21. 1. 2016
# *
# *****************************************************************************

module Tolliver
  module Models
    module NotificationReceiver
      extend ActiveSupport::Concern

      included do

        # *********************************************************************
        # Structure
        # *********************************************************************

        belongs_to :notification_delivery, class_name: Tolliver.notification_delivery_model.to_s

        # *********************************************************************
        # Validators
        # *********************************************************************

        validates_presence_of :notification_delivery_id, :receiver_ref

        # *********************************************************************
        # State
        # *********************************************************************

        enum_column :status, [
            :created,
            :sent,
            :received,
            :error
        ], default: :created

      end

      # ***********************************************************************
      # Delivery
      # ***********************************************************************

      def deliver
        self.notification_delivery.method_service.deliver(self)
      end

    end
  end
end