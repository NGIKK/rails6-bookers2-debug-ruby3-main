class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit,:update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @user = current_user
    # current_userはviewファイルに直接記述でよい。
    @book = Book.new
  end

  def edit
    #＠user = User.find(params[:id])
    #ensure_correct_userメソッドで＠userを定義しているので省略可
  end

  def update
    # @user = User.find(params[:id])
     #ensure_correct_userメソッドで＠userを定義しているので省略可
    if @user.update(user_params)
      redirect_to user_path(current_user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

end
