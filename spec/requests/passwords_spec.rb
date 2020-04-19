# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/password', type: :request do
  let(:user) { create(:user) }
  let(:url) { '/api/password' }

  context 'when params are correct' do
    let(:params) { { user: { username: user.username } } }
    before do
      post url, params: params
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'sends a reset password email' do
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to start_with 'Changement de votre mot de passe'
      expect(mail.from).to eql([ENV['MAILER_SENDER']])
      expect(mail.body.decoded).to match 'Changer mon mot de passe'
      expect(mail.body.decoded).to match '/mot-de-passe/nouveau\?token='
    end
  end

  context 'when params are not correct' do
    let(:params) { { user: { username: "bad#{user.username}" } } }
    before do
      post url, params: params
    end

    it 'returns bad request' do
      expect(response).to have_http_status(:bad_request)
    end

    it 'does not send a reset password email' do
      mail = ActionMailer::Base.deliveries.last
      expect(mail).to be_nil
    end
  end
end

RSpec.describe 'PATCH /api/password', type: :request do
  let(:password) { 'password' }
  let(:reset_token) { Devise.token_generator.generate(User, :reset_password_token) }
  let!(:user) { create(:user, reset_password_token: reset_token.last, reset_password_sent_at: Time.now.utc) }
  let(:url) { '/api/password' }

  context 'when params are correct' do
    let(:params) do
      {
        user: {
          reset_password_token: reset_token.first,
          password: password,
          password_confirmation: password
        }
      }
    end
    before do
      patch url, params: params
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'has the correct token' do
      expect(user.reset_password_token).to eql(Devise.token_generator.digest(self, :reset_password_token, reset_token.first))
    end

    it 'resets the password' do
      expect(user.reload.valid_password?(password)).to be_truthy
    end
  end

  context 'when the token is not correct' do
    let(:params) do
      {
        user: {
          reset_password_token: 'badtoken',
          password: password,
          password_confirmation: password
        }
      }
    end
    before do
      patch url, params: params
    end

    it 'returns bad request' do
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns an error for reset_password_token' do
      expect(json['errors']).to eql(['Le jeton d\'authentification n\'est pas valide'])
    end

    it 'does not reset the password' do
      expect(user.reload.valid_password?(password)).to be_falsey
    end
  end

  context 'when the password is not correct' do
    let(:params) do
      {
        user: {
          reset_password_token: reset_token.first,
          password: 'pass',
          password_confirmation: 'pass'
        }
      }
    end
    before do
      patch url, params: params
    end

    it 'returns bad_request' do
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns an error for password' do
      expect(json['errors']).to eql(['Le mot de passe est trop court (au moins 6 caractères)'])
    end

    it 'does not reset the password' do
      expect(user.reload.valid_password?(password)).to be_falsey
    end
  end
end
