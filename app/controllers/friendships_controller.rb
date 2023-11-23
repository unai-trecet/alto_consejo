# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :set_friendship, only: %i[update destroy]

  def show
    @friendship = Friendship.find(params[:id])
  end

  def create
    result = FriendshipsCreationManager.new(user_id: params[:user_id], friend_id: params[:friend_id]).call
    if result.success?
      head :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def update; end

  def destroy
    @friendship.destroy
    head :ok
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end
end
