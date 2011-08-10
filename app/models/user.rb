require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login,    :message => "is already taken."  
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_presence_of     :first_name
  validates_length_of       :first_name,    :within => 1..40
  
  validates_presence_of     :last_name
  validates_length_of       :last_name,    :within => 1..40

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 
  validates_uniqueness_of   :email,    :message => "is already taken."
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  validates_uniqueness_of   :phone, :allow_blank => true
  validates_length_of       :phone, :is => 10, :message => "must be in the format xxxxxxxxxx.", :allow_blank => true
  validates_numericality_of :phone, :message => "must be all numerical.", :allow_blank => true
  
  validates_numericality_of :lat, :message => "must be a number", :allow_blank => true
  validates_numericality_of :lng, :message => "must be a number", :allow_blank => true
 
  # override the to_param method so that we can change the way we access users
  # example /users/id -> /users/login
  def to_param
    login
  end
 
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :first_name, :last_name, :phone, :twitter, :lat, :lng, :is_admin

  # overide the render options so that certain attributes are not displayed
  def to_xml
    super(:except => [:id, :salt, :created_at, :updated_at, :crypted_password, :name, :remember_token, :remember_token_expires_at, :is_admin])
  end
  
  def to_json
   super(:except => [:id, :salt, :created_at, :updated_at, :crypted_password, :name, :remember_token, :remember_token_expires_at, :is_admin])
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  protected
    
end
