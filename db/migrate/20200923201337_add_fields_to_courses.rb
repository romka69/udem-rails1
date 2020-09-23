class AddFieldsToCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :short_description, :text, limit: 300
    add_column :courses, :language, :string, default: "English", null: false
    add_column :courses, :level, :string, default: "Beginner", null: false
    add_column :courses, :price, :integer, default: 0, null: false

    execute <<-SQL
      ALTER TABLE courses ADD CONSTRAINT price CHECK (price >= 0);
    SQL
  end
end
