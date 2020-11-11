class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :course_tags_count, null: false, default: 0

      t.timestamps
    end

    create_table :course_tags do |t|
      t.references :course, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
