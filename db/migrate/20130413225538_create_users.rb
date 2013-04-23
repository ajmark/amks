class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.integer :student_id
      t.string :password_digest
      t.string :role
      t.boolean :active, :default => true

      # t.timestamps
    end
  end
end
