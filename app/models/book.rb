class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
      favorites.exists?(user_id: user.id)
      #なぜ(user.id)だけじゃいけないのか？？user_idカラムのuser.idを指定している？
  end

 def self.looks(searches,word)
   if searches == "perfect_match"
      @book = Book.where("title LIKE ?","#{word}")
      #完全一致 Book.where(title: word)でも同じ
   elsif searches == "forward_match"
      @book = Book.where("title LIKE ?","#{word}%")
      #前方一致 Book.where('title LIKE ?', word+'%')でも同じ
   elsif searches == "backward_match"
      @book = Book.where("title LIKE ?","%#{word}")
      #後方一致 Book.where('title LIKE ?', '%'+word)でも同じ
   else
      @book = Book.where("title LIKE ?","%#{word}%")
      #部分一致。%は任意の文字列を表す。サイトに書いてあったように複数形であることに処理的な意味はない。
      # Book.where('title LIKE ?', '%'+word+'%')でも
   end
 end

end
