class CreateNotificationAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_attachments do |t|

      # Timestamps
      t.timestamps null: true

      # Relations
      t.integer :notification_id, index: true

      # Data
      t.string :name
      t.string :attachment

    end
  end
end
