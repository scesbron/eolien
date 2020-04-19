class UserMailer < ApplicationMailer

  def explain(user)
    @user = user
    mail(to: @user.email, subject: "Connexion à l'application de suivi du parc")
  end

  def reset_password(user)
    @user = user
    @token, hashed = Devise.token_generator.generate(User, :reset_password_token)
    user.reset_password_token = hashed
    user.reset_password_sent_at = Time.now.utc
    user.save
    mail(to: @user.email, subject: "Changement de votre mot de passe")
  end

  def ask_bank_account(user)
    @user = user
    mail(to: @user.email, subject: "Saisissez vos coordonnées bancaires")
  end

  def custom_email(user, subject, content)
    @user = user
    @content = content
    mail(to: user.email, subject: subject)
  end
end
