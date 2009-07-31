class Store < ActiveRecord::Base
  has_many :item_store_memberships
  has_many :items, :through => :item_store_memberships
  
  def items=(objects)
    # allows you to pass a single object or an array of objects, example "@store.items = item" or "@store.items = [item1, item2...]"
    objects = [objects] if objects.class != Array
    # maps is used to transform each item in the array turning it into the id if it is something else, to 
    # allow for code like".items= [1,4,6]" or .items = [Item.first...]
    objects.map! { |o| (o.is_a? Integer) ? o : o.id }
    # delete all records
    ItemStoreMembership.delete_all(["store_id = ?", self.id])
    # add the checked records by creating a relationship record between store and item
    objects.each do |id|
      ItemStoreMembership.create(:store_id => self.id, :item_id => id)
    end
  end
end
