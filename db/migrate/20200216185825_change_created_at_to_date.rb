class ChangeCreatedAtToDate < ActiveRecord::Migration[5.0]
  def change
    change_column :entries, :created_at, :date
  end
end
