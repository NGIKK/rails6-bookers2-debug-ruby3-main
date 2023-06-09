class BookCommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    # なぜ(params[:id])じゃないのか？
    # book_idを明示的に示している
    @book_comment = current_user.book_comments.new(book_comment_params)
    # @comment = BookComment.new(book_comment_params)
    # @comment.user_id = current_user.id
    # @comment.book_id = @book.idの3つをまとめたコード
    @book_comment.book_id = @book.id
    unless @book_comment.save
      render 'error'
    end
    #redirect_to request.referer
    #redirect_back fallback_location: books_path

  end

  def destroy
  @book = Book.find(params[:book_id])
  #book_comment = current_user.book_comments.find_by(book_id: @book.id) =>自分のコード。
  book_comment = @book.book_comments.find(params[:id])
  # =>応用課題6の解答コード
  book_comment.destroy
  # BookComment.find_by(id: params[:id], book_id: params[:book_id]).destroy
  # 上記の記述にまとめることができる。
  #redirect_to request.referer
  # redirect_back fallback_location: books_path
  end

 private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
