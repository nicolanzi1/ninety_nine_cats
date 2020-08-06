class UsersController < ApplicationController
    before_action :require_no_user!

    def create
        @user = User.new(user_params)
        if @user.save
            login_user!(@user)
            email = UserMailer.welcome_email(@user)
            email.deliver
            redirect_to cats_url
        else
            flash.now[:errors] = @users.errors.full_messages
            render :new
        end
    end

    def new
        @user = User.new
        render :new
    end

    private

    def user_params
        params.require(:user).permit(:username, :password)
    end
end