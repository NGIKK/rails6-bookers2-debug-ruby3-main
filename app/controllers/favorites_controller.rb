class FavoritesController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    #favorite = current_user.favorites.new(book_id: @book.id)
    #応用課題6の解答コード
    favorite = @book.favorites.new(user_id: current_user.id)
    favorite.save
    # redirect_to request.referer
    # redirect_back fallback_location: books_path
  end

  def destroy
    @book = Book.find(params[:book_id])
    #favorite = current_user.favorites.find_by(book_id: @book.id)
    #応用課題6の解答コード
    favorite = @book.favorites.find_by(user_id: current_user.id)
    favorite.destroy
    #redirect_to request.referer
    # redirect_back fallback_location: books_path
  end

end