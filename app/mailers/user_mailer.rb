class UserMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'
  layout 'mailer'

  def reset_password_instructions(record, token, opts={})
    opts[:subject] =  '[IPS] Account successfully activated' if record.last_sign_in_at.nil?
    super
  end
end
