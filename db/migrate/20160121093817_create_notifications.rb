class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|

      # Timestamps
      t.timestamps null: true

      # Association to template
      t.integer :notification_template_id, index: true

      # Message
      t.string :subject
      t.text :message

    end
  end
end
