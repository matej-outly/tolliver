class AddShortMessageAndPhone < ActiveRecord::Migration[6.0]
  def change
    add_column :notification_templates, :short_message, :string
    add_column :notifications, :short_message, :string

    rename_column :notification_deliveries, :sender_contact, :sender_email
    add_column :notification_deliveries, :sender_phone, :string

    rename_column :notification_receivers, :receiver_contact, :receiver_email
    add_column :notification_receivers, :receiver_phone, :string
  end
end
