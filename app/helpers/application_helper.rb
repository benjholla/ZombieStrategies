# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def page_title
    case controller.controller_name
    when 'stores'
      'Plan'
    when 'posts'
      'Announcements'
    when 'twitter_computations'
      'Zombie Twitter Computation'
    when 'twitter_trends'
      'Zombie Twitter Trends'
    else
      'Zombie Strategies'
    end
  end
  
end
