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
    module NotificationDelivery
      extend ActiveSupport::Concern

      included do

        # *********************************************************************
        # Structure
        # *********************************************************************

        belongs_to :notification, class_name: Tolliver.notification_model.to_s
        has_many :notification_receivers, class_name: Tolliver.notification_receiver_model.to_s, dependent: :destroy

        # *********************************************************************
        # Validators
        # *********************************************************************

        validates_presence_of :notification_id, :method

        # *********************************************************************
        # Delivery method
        # *********************************************************************

        enum_column :method, Tolliver.delivery_methods

        # *********************************************************************
        # Queue kind
        # *********************************************************************

        enum_column :policy, [
            :instantly,
            :batch
        ]

      end

      # ***********************************************************************
      # Delivery method
      # ***********************************************************************

      def method_service
        if @method_service.nil?
          @method_service = "Tolliver::Services::Methods::#{method_ref.to_s.capitalize}".constantize.new
        end
        @method_service
      end

      # ***********************************************************************
      # Policy
      # ***********************************************************************

      def policy
        case self.kind.to_sym
        when :email then
          :batch
        when :sms then
          :batch
        else
          :instantly
        end
      end

      def policy_service
        if @policy_service.nil?
          @policy_service = "Tolliver::Services::Policies::#{self.policy.to_s.capitalize}".constantize.new
        end
        @policy_service
      end

      # ***********************************************************************
      # Progress
      # ***********************************************************************

      def done
        if self.sent_count && self.receivers_count
          self.sent_count.to_s + "/" + self.receivers_count.to_s
        else
          nil
        end
      end

      # ***********************************************************************
      # Service
      # ***********************************************************************

      def deliver
        self.policy_service.deliver(self)
      end

    end
  end
end