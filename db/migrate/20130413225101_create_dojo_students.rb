class CreateDojoStudents < ActiveRecord::Migration
  def change
    create_table :dojo_students do |t|
      t.integer :dojo_id
      t.integer :student_id
      t.date :start_date
      t.date :end_date

      # t.timestamps
    end
  end
end
