RSpec.describe 'localisation redirects' do
  context 'without locale' do
    it 'redirects GET /exhibitions to /en/exhibitions' do
      get('/exhibitions')
      expect(response).to redirect_to('/en/exhibitions')
    end

    it 'redirects GET /exhibitions/faces-of-europe to /en/exhibitions/faces-of-europe' do
      get('/exhibitions/faces-of-europe')
      expect(response).to redirect_to('/en/exhibitions/faces-of-europe')
    end
  end

  context 'with locale in Accept-Language header' do
    it 'redirects GET /exhibitions/faces-of-europe to /fr/exhibitions/faces-of-europe' do
      headers = { 'Accept-Language' => 'fr' }
      get('/exhibitions/faces-of-europe', {}, headers)
      expect(response).to redirect_to('/fr/exhibitions/faces-of-europe')
    end

    it 'redirects GET /exhibitions to /fr/exhibitions' do
      headers = { 'Accept-Language' => 'fr' }
      get('/exhibitions', {}, headers)
      expect(response).to redirect_to('/fr/exhibitions')
    end
  end
end
