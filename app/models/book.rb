class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :read_counts, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  scope :created_today, ->{where(created_at: Time.zone.now.all_day)}
  scope :created_yesterday, ->{where(created_at: 1.day.ago.all_day)}
  # scope :created_2day_ago, ->{where(created_at: 2.day.ago.all_day)}を２〜6日分記述しなくて済む
  scope :created_days_ago, ->(n) { where(created_at: n.days.ago.all_day) }

  scope :created_this_week, ->{where(created_at: 6.day.ago.beginning_of_day .. Time.zone.now.end_of_day)}
  scope :created_last_week, ->{where(created_at: 2.week.ago.beginning_of_day .. 1.week.ago.end_of_day)}

  def self.this_week_count
   (0..6).map { |n| created_days_ago(n).count }.reverse
  end

  def favorited_by?(user)
      favorites.exists?(user_id: user.id)
      #user_idカラムからviewの引数で渡してくるuser.idが存在しているか確認している。
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
