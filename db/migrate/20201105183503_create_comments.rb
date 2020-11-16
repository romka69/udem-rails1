class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end

    add_column :users, :comments_count, :integer, null: false, default: 0
    add_column :lessons, :comments_count, :integer, null: false, default: 0
  end
end
