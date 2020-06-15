class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url = 'https://odin-facebook-54888.herokuapp.com/users/sign_in'
    mail(to: @user.email, subject: 'Welcome to Odin Facebook')
  end
end
