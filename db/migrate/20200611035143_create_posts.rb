class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.text :content
      t.references :author, foreign_key: { to_table: 'users' }

      t.timestamps
    end
    add_index :posts, [:author_id, :created_at]
  end
end
