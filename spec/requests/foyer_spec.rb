# frozen_string_literal: true
RSpec.describe 'redirects to the foyer' do
  it 'redirects GET / to /en/exhibitions/foyer' do
    get('/')
    expect(response).to redirect_to('/en/exhibitions/foyer')
  end

  it 'redirects GET /en to /en/exhibitions/foyer' do
    get('/en')
    expect(response).to redirect_to('/en/exhibitions/foyer')
  end

  it 'redirects GET /en/exhibitions to /en/exhibitions/foyer' do
    get('/en/exhibitions')
    expect(response).to redirect_to('/en/exhibitions/foyer')
  end

  it 'redirects GET /fr to /fr/exhibitions/foyer' do
    get('/fr')
    expect(response).to redirect_to('/fr/exhibitions/foyer')
  end

  it 'redirects GET /fr/exhibitions to /fr/exhibitions/foyer' do
    get('/fr/exhibitions')
    expect(response).to redirect_to('/fr/exhibitions/foyer')
  end
end
