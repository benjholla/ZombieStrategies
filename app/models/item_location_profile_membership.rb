class ItemLocationProfileMembership < ActiveRecord::Base
  belongs_to :location_profile
  belongs_to :item
end
