class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.belongs_to :requestor
      t.belongs_to :requestee
      t.string :status, default: 'pending'

      t.timestamps
    end
    add_foreign_key :relationships, :users, column: :requestor_id
    add_foreign_key :relationships, :users, column: :requestee_id

    reversible do |dir|
      up_sql = 'create unique index unique_relationship on 
                relationships(greatest(requestor_id, requestee_id), 
                least(requestor_id, requestee_id));'
      dir.up { connection.execute(up_sql) }
      
      down_sql = 'drop index unique_relationship';
      dir.down { connection.execute(down_sql) }
    end
  end
end
