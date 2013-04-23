class AddFieldsToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :fee_paid, :boolean
    add_column :registrations, :final_standing, :integer
  end
end
