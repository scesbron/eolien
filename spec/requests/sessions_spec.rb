# frozen_string_literal: true

require 'rails_helper'

def decoded_jwt_token_from_response(response)
  token_from_request = response.headers['Authorization'].split(' ').last
  JWT.decode(token_from_request, ENV['DEVISE_JWT_SECRET_KEY'], true)
end

RSpec.describe 'POST /api/login', type: :request do
  let(:user) { create(:user) }
  let(:url) { '/api/login' }
  let(:params) do
    {
      user: {
        username: user.username,
        password: user.password
      }
    }
  end

  context 'when params are correct' do
    before do
      post url, params: params
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns JTW token in authorization header' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns valid JWT token' do
      decoded_token = decoded_jwt_token_from_response(response)
      expect(decoded_token.first['sub']).to be_present
    end
  end

  context 'when login params are incorrect' do
    before { post url }

    it 'returns unathorized status' do
      expect(response.status).to eq 401
    end
  end
end

RSpec.describe 'DELETE /api/logout', type: :request do
  let(:url) { '/api/logout' }

  it 'returns 204, no content' do
    delete url
    expect(response).to have_http_status(204)
  end
end
