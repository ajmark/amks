class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :event_id
      t.integer :min_age
      t.integer :max_age
      t.integer :min_rank
      t.integer :max_rank
      t.boolean :active, :default => true

      # t.timestamps
    end
  end
end
