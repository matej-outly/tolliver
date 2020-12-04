module Tolliver
  module Jobs
    class BatchPolicyJob < ActiveJob::Base
      queue_as :default

      def perform(notification_delivery_id, batch_size)

        # Instantiate notification delivery object
        notification_delivery = Tolliver.notification_delivery_model.find_by_id(notification_delivery_id)
        return nil if notification_delivery.nil? || notification_delivery.policy != :batch

        # Call policy logic
        policy_service = Tolliver::Services::Policies::Batch.new
        policy_service.deliver_batch_and_enqueue(notification_delivery, batch_size)

      end
    end
  end
end