class CreateRicNotificationNotificationTemplates < ActiveRecord::Migration
	def change
		create_table :notification_templates do |t|

			# Timestamps
			t.timestamps null: true
			
			# Identification
			t.string :ref
			
			# Message
			t.string :subject 
			t.text :message

			# Handlers
			t.boolean :disabled
			t.boolean :dry
			
		end
	end
end
