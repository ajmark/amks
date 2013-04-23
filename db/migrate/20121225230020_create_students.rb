class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.integer :rank
      t.string :phone
      t.boolean :waiver_signed, :default => false
      t.boolean :active, :default => true

      # t.timestamps
    end
  end
end
