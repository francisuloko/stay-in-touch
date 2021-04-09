class FriendshipsController < ApplicationController
  def index
    @friendships = Friendship.all
  end

  def create
    @friendship = Friendship.new(friendship_params)
    invitee_path = "/users/#{params[:friendship][:invitee_id]}"

    if @friendship.save
      redirect_to invitee_path, notice: "Friend request was sent."
    else
      redirect_to invitee_path, notice: "Friend request cannot be sent."
    end
  end

  def destroy
    friendship = Friendship.find_by(friendship_params)
    if friendship
      friendship.destroy
      redirect_to user_path, notice: 'Friendship request rejected.'
    else
      redirect_to user_path, alert: 'Please try again.'
    end
  end

  private

  def friendship_params
    params.require(:friendship).permit(:inviter_id, :invitee_id, :status)
  end
end
