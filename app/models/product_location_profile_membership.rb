class ProductLocationProfileMembership < ActiveRecord::Base
  belongs_to :location_profile
  belongs_to :product
end
