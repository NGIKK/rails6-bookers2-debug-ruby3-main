class RelationshipsController < ApplicationController

  def create
    #user = User.find(params[:user_id])
    #relationship = current_user.relationships.new(followed_id: user.id)
    #relationship.save
    user = User.find(params[:user_id])
    current_user.follow(user)
    #current_user.follow(params[:user_id])
    #上記は自分の記述。params[:user_id]の（小文字のモデル名）_idは
    #そのモデルのidということを明示的に表している。
    redirect_to request.referer
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    #current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  def followings
    user = User.find(params[:user_id])
    @followings = user.followings
    #なぜfollowed_idじゃない？
  end

  def followers
    user  = User.find(params[:user_id])
    @followers = user.followers
    #なぜfollower_idじゃない？？
  end


end
