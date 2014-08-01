require 'rails_helper'

RSpec.describe InvoicesController, :type => :controller do
  pending 'POST create' do
    it 'creates an invoice resource' do
      expected_filename = 'foo/bar/foo.png'
      expect(KuluService::API).to receive(:create_invoice).with(expected_filename)
      post :create, invoice: { filename: 'foo.png', url_prefix: 'foo/bar/${filename}' }
    end

    it 'redirects to the root path' do
      post :create, invoice: { filename: 'foo.png', url_prefix: 'foo/bar/${filename}' }
      expect(response).to redirect_to(root_path)
    end
  end
end
