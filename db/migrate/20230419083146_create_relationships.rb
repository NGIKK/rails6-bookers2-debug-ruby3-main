class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships,[:follower_id, :followed_id],unique: true
    # follower_idとfollowed_idの組み合わせが必ずユニークであることを保証する仕組み。
    # ユーザーが何らかの方法でRelationshipのデータを操作しても一意なインデックスを追加していれば、
    # エラーを発生させて重複を防ぐことができる
  end
end
