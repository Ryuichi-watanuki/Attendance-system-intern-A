class AddTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :basic_time, :time
    add_column :users, :specified_working_hour, :time
  end
end
