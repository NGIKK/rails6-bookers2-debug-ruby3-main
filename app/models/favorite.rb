class Favorite < ApplicationRecord
  
  belongs_to :user
  belongs_to :book
  # validates_uniqueness_of :book_id, scope: :user_id
  # いいねとbook_idの一意性を持たせる記述。scopeで１ユーザーに適用範囲を限定している。
  # 限定しないと誰か1ユーザーがいいねすると他のユーザーはいいねできなくなる？
end
