class CategoryLocationProfileMembership < ActiveRecord::Base
  belongs_to :location_profile
  belongs_to :category
end
