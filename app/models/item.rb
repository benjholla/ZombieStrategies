class Item < ActiveRecord::Base
  has_many :item_store_memberships
  has_many :stores, :through => :item_store_memberships
end
