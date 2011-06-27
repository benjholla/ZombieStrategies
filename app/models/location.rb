class Location < ActiveRecord::Base
  belongs_to :location_profile
  belongs_to :location_classification
  
  has_many :category_location_memberships
  has_many :categories, :through => :category_location_memberships
  
  has_many :item_location_memberships
  has_many :items, :through => :item_location_memberships
  
  validates_presence_of     :lat
  validates_presence_of     :lng
  validates_presence_of     :location_profile
  validates_presence_of     :location_classification
  
  # virtual attribute, more info in railscast #16
  def location_profile_name
    location_profile.name if location_profile
  end
  
  def location_profile_name=(name)
    self.location_profile = LocationProfile.find_or_create_by_name(name) unless name.blank?
  end
  
end