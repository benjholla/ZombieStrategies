class LocationProfile < ActiveRecord::Base
  has_many :category_location_profile_memberships
  has_many :categories, :through => :category_location_profile_memberships
  
  has_many :product_location_profile_memberships
  has_many :products, :through => :product_location_profile_memberships
  
end