class CreateBases < ActiveRecord::Migration[5.1]
  def change
    create_table :bases do |t|
      t.integer :number
      t.string :name
      t.string :kind

      t.timestamps
    end
  end
end
