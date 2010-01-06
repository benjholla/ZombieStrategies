class Location < ActiveRecord::Base
  belongs_to :location_profile
  
  # virtual attribute, more info in railscast #16
  def location_profile_name
    location_profile.name if location_profile
  end
  
  def location_profile_name=(name)
    self.location_profile = LocationProfile.find_or_create_by_name(name) unless name.blank?
  end
  
end