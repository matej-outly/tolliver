class AddNotificationAttachmentsUrl < ActiveRecord::Migration[6.0]
  def change
    change_column :notification_attachments, :attachment, :text
    add_column :notification_attachments, :url, :string
  end
end
