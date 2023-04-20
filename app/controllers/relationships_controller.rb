class RelationshipsController < ApplicationController

  def create
    #user = User.find(params[:user_id])
    #relationship = current_user.relationships.new(followed_id: user.id)
    #relationship.save
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  def destroy
    current_user.unfollow(params[:user_id])
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
