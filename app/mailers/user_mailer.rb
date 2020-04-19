class UserMailer < ApplicationMailer

  def explain(user)
    @user = user
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
end
