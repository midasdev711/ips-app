class DealershipMailer < ApplicationMailer
  default from: "no-reply@ips.ca"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.dealership_mailer.deactivation_notification.subject
  #
  def deactivation_notification(record)

    mail to: record.email
  end
end
