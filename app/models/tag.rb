class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy, foreign_key: 'tag_id'
  has_many :books, through: :taggings
  
  validates :name, uniqueness: true, presence: true

      
end
