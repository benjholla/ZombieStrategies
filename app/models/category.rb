class Category < ActiveRecord::Base
  has_many :products
  
  has_many :category_location_profile_memberships
  has_many :location_profiles, :through => :category_location_profile_memberships
  
  def category_ids=(category_ids)
    categories.each do |category|
      category.destroy unless category_ids.include? category.category_id
    end

    category_ids.each do |category_id|
      self.categories.create(:category_id => category_id) unless categories.any? { |c| c.category_id == category_id }
    end
  end
  
end
