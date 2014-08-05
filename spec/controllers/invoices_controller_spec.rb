require 'rails_helper'

RSpec.describe InvoicesController, :type => :controller do
  context 'POST create' do
    it 'creates an invoice resource' do
      expect(Invoice).to receive(:create) { Invoice.new }
      post :create, invoice: { filename: 'foo.png', url_prefix: 'foo/bar/${filename}' }
    end

    it 'redirects to the root path' do
      allow(Invoice).to receive(:create) { Invoice.new }
      post :create, invoice: { filename: 'foo.png', url_prefix: 'foo/bar/${filename}' }

      expect(response).to redirect_to(root_path)
    end
  end
end
