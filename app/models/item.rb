class Item < ActiveRecord::Base
  belongs_to :category
  
  has_many :item_location_profile_memberships
  has_many :location_profiles, :through => :item_location_profile_memberships
  
  has_many :item_location_memberships
  has_many :locations, :through => :item_location_memberships
  
  validates_uniqueness_of   :name,    :message => ": There is already a item with this name."
  validates_format_of       :name,    :with => /\A[a-zA-Z0-9 '-.\/]+\z/
  validates_length_of       :name,    :maximum => 50
  
  # virtual attribute, more info in railscast #16
  def category_name
    category.name if category
  end
  
  def category_name=(name)
    self.category = Category.find_or_create_by_name(name) unless name.blank?
  end
  
  def item_ids=(item_ids)
    items.each do |item|
      item.destroy unless item_ids.include? item.item_id
    end

    item_ids.each do |item_id|
      self.items.create(:item_id => item_id) unless items.any? { |p| p.item_id == item_id }
    end
  end
  
end
