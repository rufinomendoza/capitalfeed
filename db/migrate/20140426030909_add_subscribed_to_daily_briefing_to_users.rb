class AddSubscribedToDailyBriefingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscribed_to_daily_briefing, :boolean, default: true
  end
end
