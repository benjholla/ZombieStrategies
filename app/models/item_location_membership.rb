class ItemLocationMembership < ActiveRecord::Base
  belongs_to :location
  belongs_to :item
end
