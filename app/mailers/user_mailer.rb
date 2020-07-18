class UserMailer < ApplicationMailer

  def explain(user)
    @user = user
    @password = password = Devise.friendly_token.first(8)
    @user.update!(password: @password)
    mail(to: @user.email, subject: "Connexion à l'application de suivi du parc")
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

  def error(subject, error)
    @error = error
    mail(to: ENV['MAILER_SENDER'], subject: subject)
  end
end
