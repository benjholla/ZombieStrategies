class LocationClassification < ActiveRecord::Base
  
  has_many :locations
  
  validates_uniqueness_of   :name,    :message => ": There is already a location classification with this name."
  validates_format_of       :name,    :with => /\A[a-zA-Z0-9 '-]+\z/
  validates_length_of       :name,    :maximum => 30
  
  validates_uniqueness_of   :icon,    :message => ": There is already a location classification with this name."
  validates_format_of       :icon,    :with => URI::regexp(%w(http https))  
  
end
