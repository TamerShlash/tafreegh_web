class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :fbid, null: false
      t.string :name
      t.string :email
      t.string :oauth_token
      t.datetime :oauth_expires_at

      t.timestamps
    end

    add_index :users, :fbid, unique: true
    add_index :users, :email, unique: true
  end
end
