class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,                     :string, :limit => 40
      t.column :name,                      :string, :limit => 100, :default => '', :null => true
      t.column :email,                     :string, :limit => 100
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime
      t.column :first_name,                :string, :limit => 40
      t.column :last_name,                 :string, :limit => 40
      t.column :phone,                     :string, :limit => 40
      t.column :twitter,                   :string, :limit => 40
      t.column :lat, :decimal, :precision => 15, :scale => 10
      t.column :lng, :decimal, :precision => 15, :scale => 10
      t.boolean :is_admin,                  :default => false
      t.timestamps 
    end
    add_index :users, :login, :unique => true
    @user = User.create(:login=>"admin", :password=>"***REMOVED***", :password_confirmation=>"***REMOVED***", :first_name=>"Ben", :last_name=>"Holland", :email=>"***REMOVED***@gmail.com", :phone=>"***REMOVED***", :twitter=>"***REMOVED***", :lat=>"***REMOVED***", :lng=>"***REMOVED***")
    # set this user to admin
    @user.is_admin = 1
    if @user && @user.save
      puts "Success: created new admin user with default password = ***REMOVED***, remember to change the password!"
    else
      puts "Error: could not create default user!"
    end
  end

  def self.down
    drop_table "users"
  end
end
