class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :read_counts, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags,through: :taggings

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  scope :created_today, ->{where(created_at: Time.zone.now.all_day)}
  scope :created_yesterday, ->{where(created_at: 1.day.ago.all_day)}
  # scope :created_2day_ago, ->{where(created_at: 2.day.ago.all_day)}を２〜6日分記述しなくて済む
  scope :created_days_ago, ->(n) { where(created_at: n.days.ago.all_day) }

  scope :created_this_week, ->{where(created_at: 6.day.ago.beginning_of_day .. Time.zone.now.end_of_day)}
  scope :created_last_week, ->{where(created_at: 2.week.ago.beginning_of_day .. 1.week.ago.end_of_day)}
  
  scope :latest, ->{order(created_at: :desc)}
  scope :score_count, ->{order(score: :desc)}
  
  def self.this_week_count
   (0..6).map { |n| created_days_ago(n).count }.reverse
  end

  def favorited_by?(user)
      favorites.exists?(user_id: user.id)
      #user_idカラムからviewの引数で渡してくるuser.idが存在しているか確認している。
  end
 
 def save_tag(tag_name)
  ActiveRecord::Base.transaction do
  self.tags = tag_name.map { |name| Tag.find_or_initialize_by(name: name.strip) }
  save!
  end
   true
 rescue StandardError
   false
 end
  # タグが存在していれば、タグの名前を配列として全て取得
    # current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    # old_tags = current_tags - sent_tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    # new_tags = sent_tags - current_tags

    # 古いタグを消す
    # old_tags.each do |old|
      # self.tags.delete　Tag.find_by(name: old)
    # end

    # 新しいタグを保存
    # new_tags.each do |new|
      # new_post_tag = Tag.find_or_create_by(name: new)
      # self.tags << new_post_tag
  # end
# end


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
