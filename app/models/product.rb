class Product < ActiveRecord::Base
  belongs_to :category
  
  has_many :product_location_profile_memberships
  has_many :location_profiles, :through => :product_location_profile_memberships
  
  has_many :product_location_memberships
  has_many :locations, :through => :product_location_memberships
  
  # virtual attribute, more info in railscast #16
  def category_name
    category.name if category
  end
  
  def category_name=(name)
    self.category = Category.find_or_create_by_name(name) unless name.blank?
  end
  
  def product_ids=(product_ids)
    products.each do |product|
      product.destroy unless product_ids.include? product.product_id
    end

    product_ids.each do |product_id|
      self.products.create(:product_id => product_id) unless products.any? { |p| p.product_id == product_id }
    end
  end
  
end
