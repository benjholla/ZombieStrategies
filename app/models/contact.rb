class Contact < Tableless
  column :name,          :string
  column :email_address, :string
  column :message,       :text
  
  validates_presence_of :name, :email_address, :message
end