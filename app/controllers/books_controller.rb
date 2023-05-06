class BooksController < ApplicationController
   before_action :ensure_correct_user, only: [:edit,:update]

  def show
    @user = current_user
    @book = Book.find(params[:id])
    @book_new = Book.new
    @book_comment = BookComment.new
   unless ReadCount.find_by(user_id: current_user,book_id: @book.id)
    read_count = ReadCount.new(book_id: @book.id,user_id: @user.id)
    read_count.save
    #read_count = current_user.read_counts.create(book_id: @book.id)
    #アソシエーションを利用して１つにまとめた記述
    #各ユーザー1日一回まで閲覧数を記録する場合find_byの前につける where(created_at: Time.zone.now.all_day)
   end
  end

  def index
    to = Time.current.at_end_of_day
    #Timeクラス
    #今日の23:59
    #『Time.now』『Date.today』『DateTime.now』は環境変数またはシステムのタイムゾーン設定を、
    #『Time.current』などのcurrentは`application.rb`に設定したタイムゾーン設定を利用
    from = (to - 6.day).at_beginning_of_day
    #toから6日前の0:00
    @book = Book.new
    @books = Book.all.sort_by{|x|
    x.favorites.where(created_at: from...to).size}.reverse
    #Book.includes(:favorites)とBook.allは同じ処理結果
    #includesメソッド アソシエーションの関連名を指定する。
    @user = current_user
    # current_userはviewファイルに直接記述でよい?
  end

  def create
    @user = current_user
    @books = Book.all
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      #@books = Book.all
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
    # unless @book.user == current_user
      # redirect_to books_path
    # end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id), notice: "You have updated book successfully."
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title,:body)
  end

# メソッドを定義してbefore_actionする
   def ensure_correct_user
     @book = Book.find(params[:id])
     unless @book.user == current_user
       redirect_to books_path
     end
   end

end