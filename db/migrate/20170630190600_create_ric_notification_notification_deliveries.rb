class CreateRicNotificationNotificationDeliveries < ActiveRecord::Migration
	def change
		create_table :notification_deliveries do |t|

			# Timestamps
			t.timestamps null: true
			t.datetime :sent_at
			
			# Relations
			t.integer :notification_id, index: true
			
			# Delivery kind (email, SMS, mailboxer, ...)
			t.string :kind

			# Statistics
			t.integer :receivers_count
			t.integer :sent_count
		end
	end
end
