class MotifyTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :status, :integer
  end
end
