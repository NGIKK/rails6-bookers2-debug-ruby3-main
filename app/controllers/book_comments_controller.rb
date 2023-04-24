class BookCommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    # なぜ(params[:id])じゃないのか？Bookコントローラーじゃないから？
    @comment = current_user.book_comments.new(book_comment_params)
    # comment = PostComment.new(post_comment_params)
    # comment.user_id = current_user.id の二つをまとめたコード
    @comment.book_id = @book.id
    @comment.save
    #redirect_to request.referer
    #redirect_back fallback_location: books_path

  end

  def destroy
  @book = Book.find(params[:book_id])
  @comment = current_user.book_comments.find_by(book_id: @book.id)
  @comment.destroy
  #@book_comment = BookComment.new
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
