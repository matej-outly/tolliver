class CreateRicNotificationNotifications < ActiveRecord::Migration
	def change
		create_table :notifications do |t|

			# Timestamps
			t.timestamps null: true
			
			# Association to template
			t.integer :notification_template_id, index: true

			# Kind
			t.string :kind

			# Message
			t.string :subject
			t.text :message

			# Attachments
			t.string :url
			t.string :attachment

			# Sender
			t.integer :sender_id, index: true
			t.string :sender_type, index: true

		end
	end
end
