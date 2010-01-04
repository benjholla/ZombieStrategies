class Product < ActiveRecord::Base
  belongs_to :category
  
  # virtual attribute, more info in railscast #16
  def category_name
    category.name if category
  end
  
  def category_name=(name)
    self.category = Category.find_or_create_by_name(name) unless name.blank?
  end
  
end
