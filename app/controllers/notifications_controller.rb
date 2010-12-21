class NotificationsController < ApplicationController
  def index
  end

  def create
    @contact = Contact.new(params['contact'])
    puts "------------------------------------"
    puts @contact
    Notifier.deliver_gmail_message(@contact)
    flash[:notice] = 'Your message has been sent.'
    redirect_to root_path
  end

end
