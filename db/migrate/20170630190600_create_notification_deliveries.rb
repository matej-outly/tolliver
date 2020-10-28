class CreateNotificationDeliveries < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_deliveries do |t|

      # Timestamps
      t.timestamps null: true
      t.datetime :sent_at

      # Relations
      t.integer :notification_id, index: true

      # Delivery method (email, SMS, ...)
      t.string :method

      # Sender
      t.string :sender_ref, index: true
      t.string :sender_contact

      # Postpone
      t.boolean :is_postponed

      # Statistics
      t.integer :receivers_count
      t.integer :sent_count
    end
  end
end
