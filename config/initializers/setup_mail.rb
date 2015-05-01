ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
	:address 			=> 'smtp.sendgrid.net',
	:port				=> '587',
	:authentication 		=> :plain,
	:user_name			=> 'app36377753@heroku.com', 
	:password			=> 'xlooxlof2669',
	:domain			=> 'heroku.com',
	:enable_starttls_auto		=> true
}