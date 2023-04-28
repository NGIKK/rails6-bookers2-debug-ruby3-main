class MessagesController < ApplicationController
  
  def create
    if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
    @message = Messages.new(message_params)
     if @message.save
      redirect_to room_path(@message.room_id)
     end
    else
      redirect_back(fallback_location: root_path)
    end
  end
  
  private
  
  def message_params
    params.require(:message).permit(:user_id,:room_id,:body).merge(user_id: current_user.id)
  end

end
