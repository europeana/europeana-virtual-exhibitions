# frozen_string_literal: true
RSpec.describe 'alchemy admin requests' do
  it 'redirects to login page' do
    get('/exhibitions/admin/pages')
    expect(response).to redirect_to('/exhibitions/admin/login')
  end
end
