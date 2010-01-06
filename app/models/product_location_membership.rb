class ProductLocationMembership < ActiveRecord::Base
  belongs_to :location
  belongs_to :product
end
