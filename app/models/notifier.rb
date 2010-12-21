class Notifier < ActionMailer::Base
  
  def gmail_message(contact)
    @recipients = 'contact@zombiestrategies.com' 
    @from = '***REMOVED***' 
    @subject = '[ZombieStategies.com] Contact Form Request'
    @body['name'] = contact.name
    @body['email'] = contact.email_address 
    @body['message'] = contact.message
  end

end
