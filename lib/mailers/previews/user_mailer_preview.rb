class UserMailerPreview < ActionMailer::Preview

  def reset_password_instructions
    UserMailer.reset_password_instructions(User.last, "faketoken", {})
  end
  def activation_email
    user = User.last
    user.last_sign_in_at = nil
    UserMailer.reset_password_instructions(user, "faketoken", {})
  end

end
