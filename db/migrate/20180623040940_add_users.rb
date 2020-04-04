class AddUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :d_start_worktime, :datetime
    add_column :users, :d_end_worktime, :datetime
    add_column :users, :basic_work_time, :datetime
    add_column :users, :worker_number, :integer
    add_column :users, :worker_id, :string
  end
end
