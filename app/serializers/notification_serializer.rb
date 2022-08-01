# frozen_string_literal: true

class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :type, :params, :start_at, :end_at

  belongs_to :recipient do
    attributes :id, :username, :email
  end
end
