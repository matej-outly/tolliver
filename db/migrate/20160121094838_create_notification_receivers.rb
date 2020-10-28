class CreateNotificationReceivers < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_receivers do |t|

      # Timestamps
      t.timestamps null: true
      t.datetime :sent_at
      t.datetime :received_at

      # Relations
      t.integer :notification_delivery_id, index: true

      # Receiver
      t.string :receiver_ref, index: true
      t.string :receiver_contact

      # State
      t.string :status
      t.string :error_message

    end
  end
end
