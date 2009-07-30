class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :username
      t.string :password
      t.string :confirm_password
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :twitter
      t.column :lat, :decimal, :precision => 15, :scale => 10
      t.column :lng, :decimal, :precision => 15, :scale => 10
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
