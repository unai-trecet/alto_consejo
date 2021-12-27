# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/notifications", type: :request do
  let(:user) { create(:user, :confirmed) }

  let(:valid_attributes) do
    { recipient: user,
      type: 'MatchInvitationNotification',
      params: { match: create(:match).attributes },
      read_at: '2021-12-01 17:47:54' }
  end

  let(:invalid_attributes) {
    valid_attributes.merge(recipient: nil)
  }

  describe "GET /index" do
    def call_action
      get notifications_url
    end

    it_behaves_like 'not_logged_in'

    context 'authenticated' do
      before { sign_in(user) }

      it "renders only notifications belong current_user" do
        create_list(:notification, 2, recipient: user)
        create(:notification)

        call_action
        binding.pry
        expect(response).to be_successful
      end
    end

  end

  describe "GET /show" do
    it "renders a successful response" do
      notification = Notification.create! valid_attributes
      get notification_url(notification)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_notification_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      notification = Notification.create! valid_attributes
      get edit_notification_url(notification)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Notification" do
        expect {
          post notifications_url, params: { notification: valid_attributes }
        }.to change(Notification, :count).by(1)
      end

      it "redirects to the created notification" do
        post notifications_url, params: { notification: valid_attributes }
        expect(response).to redirect_to(notification_url(Notification.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Notification" do
        expect {
          post notifications_url, params: { notification: invalid_attributes }
        }.to change(Notification, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post notifications_url, params: { notification: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested notification" do
        notification = Notification.create! valid_attributes
        patch notification_url(notification), params: { notification: new_attributes }
        notification.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the notification" do
        notification = Notification.create! valid_attributes
        patch notification_url(notification), params: { notification: new_attributes }
        notification.reload
        expect(response).to redirect_to(notification_url(notification))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        notification = Notification.create! valid_attributes
        patch notification_url(notification), params: { notification: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested notification" do
      notification = Notification.create! valid_attributes
      expect {
        delete notification_url(notification)
      }.to change(Notification, :count).by(-1)
    end

    it "redirects to the notifications list" do
      notification = Notification.create! valid_attributes
      delete notification_url(notification)
      expect(response).to redirect_to(notifications_url)
    end
  end
end
