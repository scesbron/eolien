require 'rails_helper'


RSpec.describe 'GET /api/user', type: :request do
  let(:user) { create(:user, birth_date: Date.today) }
  let(:url) { '/api/user' }


  context 'when user is not authenticated' do
    before { get url }
    it 'returns 401' do
      expect(response).to have_http_status(401)
    end
  end

  context 'when user is authenticated' do
    before do
      login_as(user, scope: :user)
      get url
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end
    it 'returns the correct json' do
      puts json
      expect(json['firstname']).to eq(user.firstname)
      expect(json['lastname']).to eq(user.lastname)
      expect(json['email']).to eq(user.email)
      expect(json['username']).to eq(user.username)
      expect(json['password']).to be_nil
    end
  end
end
