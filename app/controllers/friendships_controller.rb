# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :set_friendship, only: %i[update destroy]

  def show
    @friendship = Friendship.find(params[:id])
  end

  def update
    # TODO: Implementar la lógica de actualización
  end

  def destroy
    @friendship.destroy
    head :ok
  end

  def create
    result = FriendshipsCreationManager.new(user_id: params[:user_id], friend_id: params[:friend_id]).call
    if result.success?
      handle_create_success(result)
    else
      handle_create_failure(result)
    end
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end

  def handle_create_success(result)
    render json: { status: 'success', message: result.message }
  end

  def handle_create_failure(result)
    render json: { status: 'error', message: result.errors }, status: :unprocessable_entity
  end
end
