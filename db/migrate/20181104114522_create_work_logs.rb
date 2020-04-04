class CreateWorkLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :work_logs do |t|
      t.integer :user_id
      t.date :day
      t.datetime :start_time
      t.datetime :end_time
      t.datetime :starttime_change
      t.datetime :endtime_change
      t.string :work_check
      t.references :work, foreign_key: true

      t.timestamps
    end
  end
end
