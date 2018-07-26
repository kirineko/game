class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.integer :task_id 
      t.string :color
      t.integer :point
      t.string :content
      t.timestamps
    end
  end
end
