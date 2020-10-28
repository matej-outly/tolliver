# *****************************************************************************
# * Copyright (c) 2019 Matěj Outlý
# *****************************************************************************
# *
# * Notification template
# *
# * Author: Matěj Outlý
# * Date  : 9. 5. 2016
# *
# *****************************************************************************

module Tolliver
  module Models
    module NotificationTemplate
      extend ActiveSupport::Concern

      included do

        # *********************************************************************
        # Structure
        # *********************************************************************

        has_many :notifications, class_name: Tolliver.notification_model.to_s, dependent: :nullify

        # *********************************************************************
        # Validators
        # *********************************************************************

        validates_presence_of :ref, :subject
        validates :ref, uniqueness: true

      end

      module ClassMethods

        def permitted_columns
          [
              :ref,
              :subject,
              :message,
              :is_disabled,
              :is_dry
          ]
        end

      end

    end
  end
end