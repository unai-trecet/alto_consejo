# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :set_friendship, only: %i[show update delete]

  def show
    @friendship = Friendship.find(params[])
  end

  def new; end

  def create
    result = FriendshipCreationManager.new(user_id: current_user.id, friend_id: params[:friend_id]).call

    nil unless result.success?
  end

  def update; end

  def destroy; end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end
end
