class CreateBuybidBatchTimeSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :buybid_batch_time_schedules do |t|
      t.string :schedule_key
      t.string :task_name
      t.integer :repeat_time
      t.string :repeat_type
      t.integer :repeat_num
      t.datetime :repeat_start
      t.boolean :actived
      t.string :schedule_data
    	
      t.timestamps
    end
  end
end
