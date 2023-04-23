class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books,dependent: :destroy
  has_many :favorites,dependent: :destroy
  has_many :book_comments,dependent: :destroy



  #受動的関係。フォローされる
   # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship",foreign_key: "followed_id", dependent: :destroy
   # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower

 #能動的関係。フォローする
   # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship",foreign_key: "follower_id", dependent: :destroy
   # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed



  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  # presence: true はミニマムが２で指定されているので不要？
  validates :introduction,length: {maximum: 50 }



  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end


  def follow(user)
      relationships.create(followed_id: user.id)
  end

  def unfollow(user)
      relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
      followings.include?(user)
  end

  def self.looks(searches,words)
   if searches == "perfect_match"
      @user = User.where("name LIKE ?","#{words}")
      #完全一致
   elsif searches == "forward_match"
      @user = User.where("name LIKE ?","#{words}%")
      #前方一致
   elsif searches == "backward_match"
      @user = User.where("name LIKE ?","%#{words}")
      #後方一致
   else
      @user = User.where("name LIKE ?","%#{words}%")
      #部分一致。%は任意の文字列を表す。複数形であることに処理的な意味はない。
   end
  end

end
