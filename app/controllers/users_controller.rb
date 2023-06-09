class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit,:update]

  def show
    @tag = Tag.all
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
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

  def search
    user = User.find(params[:user_id]) #なぜ明示的にuser_idを指定する必要があるのか？
    books = user.books
      # フォームから送信されたパラメーターをdate型に変換し、その日1日分のデータを取得
      if params[:created_at] == ""
         @search_book = "日付を選択してください"
      else
       @search_book = books.where(created_at: params[:created_at].to_date.all_day).count
      end
      #render :search
      #下記調べた記述。文字列検索をしている。選択が空白の場合の条件分岐も記載
      #if params[:created_at] == ""
         #@search_book = "日付を選択してください"
      # 日付選択が空白の場合(＝ created_atパラメーターを送信していない場合）の処理を記載しない場合、
      # そのユーザーの全投稿数が表示される。(wherメソッドを前方一致で使用しているため、空だと全て一致する)
      #else
      # created_at = params[:created_at]
      #@search_book = books.where('created_at LIKE ? ', "#{created_at}%").count
      #end
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
