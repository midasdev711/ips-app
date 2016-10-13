class DealershipMailerPreview < ActionMailer::Preview

  def deactivation_notification
    DealershipMailer.deactivation_notification(Dealership.last.users.last)
  end

end
