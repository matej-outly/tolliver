class CreateNotificationTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_templates do |t|

      # Timestamps
      t.timestamps null: true

      # Identification
      t.string :ref, index: true

      # Message
      t.string :subject
      t.text :message

      # Handlers
      t.boolean :is_disabled
      t.boolean :is_dry

    end
  end
end
