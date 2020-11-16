class AddPublishAndApprovedToCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :published, :boolean,
               default: false, null: false
    add_column :courses, :approved, :boolean,
               default: false, null: false
  end
end
