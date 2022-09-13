# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Attachments', type: :request do
  let(:user) { create(:user, :confirmed) }

  describe 'GET /purge_attachment' do
    def call_action(id = user.avatar.id)
      delete purge_attachment_url(id)
    end

    it_behaves_like 'not_logged_in'

    describe 'authenticated user' do
      let(:match) { create(:match, user:) }

      before do
        sign_in user
        match.pictures.attach(
          io: File.open(Rails.root.join('app', 'assets', 'images', 'default_avatar.png')),
          filename: 'default_avatar.png',
          content_type: 'image/png'
        )
      end

      it 'deletes passed attachment' do
        expect(match.pictures.count).to eq(1)

        call_action(match.pictures.first.id)

        match.reload
        expect(match.pictures).to be_blank
        expect(response).to have_http_status(302)
      end

      it 'does not delete attachment if its record user is not current user' do
        another_user = create(:user, :confirmed)
        match.update(user: another_user)
        expect(match.pictures.count).to eq(1)

        call_action(match.pictures.first.id)

        match.reload
        expect(match.pictures.count).to eq(1)
        expect(match.pictures.first.filename).to eq('default_avatar.png')
        expect(response).to have_http_status(302)
      end
    end
  end
end
