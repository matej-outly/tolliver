module Tolliver
  module Jobs
    class DeliveryJob < ActiveJob::Base
      queue_as :default

      def perform(notification_id)

        # Instantiate notification object
        notification = Tolliver.notification_model.find_by_id(notification_id)
        return nil if notification.nil?

        # Call standard API
        Tolliver::Services::DeliveryService.instance.deliver(notification)

      end
    end
  end
end