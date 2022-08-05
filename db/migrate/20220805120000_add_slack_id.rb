class AddSlackId < ActiveRecord::Migration[6.0]
  def change
    add_column :notification_receivers, :receiver_slack_id, :string
  end
end
