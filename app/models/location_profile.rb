class LocationProfile < ActiveRecord::Base
  has_many :category_location_profile_memberships
  has_many :categories, :through => :category_location_profile_memberships
  
  has_many :item_location_profile_memberships
  has_many :items, :through => :item_location_profile_memberships
  
  has_many :locations
  
  validates_uniqueness_of   :name,    :message => ": There is already a location profile with this name."
  validates_format_of       :name,    :with => /\A[a-zA-Z0-9 '-,()\/]+\z/
  validates_length_of       :name,    :maximum => 50
  
  # overrice the to_param method so that we can change the way we access location_profiles
  # example /location_profiles/id -> /location_profiles/name
  def to_param
    name
  end

end