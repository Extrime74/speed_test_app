class CreateTestResults < ActiveRecord::Migration[7.1]
  def change
    create_table :test_results do |t|
      t.float :upload_time
      t.float :download_time
      t.string :user_agent

      t.timestamps
    end
  end
end
