class AddDetailsToWork < ActiveRecord::Migration[5.1]
  def change
    add_column :works, :endtime_plan, :datetime
    add_column :works, :starttime_change, :datetime
    add_column :works, :endtime_change, :datetime
    add_column :works, :work_content, :text
    add_column :works, :over_check, :string
    add_column :works, :month_check, :string
    add_column :works, :work_check, :string
  end
end
