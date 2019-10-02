class CreateRicNotificationNotificationReceivers < ActiveRecord::Migration
	def change
		create_table :notification_receivers do |t|

			# Timestamps
			t.timestamps null: true
			t.datetime :sent_at
			t.datetime :received_at

			# Relations
			t.integer :notification_delivery_id, index: true
			t.integer :receiver_id, index: true
			t.string :receiver_type, index: true

			# State
			t.string :state
			t.string :error_message

		end
	end
end
