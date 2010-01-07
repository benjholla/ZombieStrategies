class LocationProfile < ActiveRecord::Base
  has_many :category_location_profile_memberships
  has_many :categories, :through => :category_location_profile_memberships
  
  has_many :product_location_profile_memberships
  has_many :products, :through => :product_location_profile_memberships
  
  has_many :locations
  
  validates_uniqueness_of   :name,    :message => ": There is already a location profile with this name." 
  
  # overrice the to_param method so that we can change the way we access location_profiles
  # example /location_profiles/id -> /location_profiles/name
  def to_param
    name
  end

end