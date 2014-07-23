require 'rails_helper'

RSpec.describe InvoicesController, :type => :controller do
  context 'POST create' do
    it 'creates an invoice resoure' do
      expected_filename = "foo/bar/foo.png"
      expect_any_instance_of(KuluService).to receive(:create_invoice).with(expected_filename)
      post :create, invoice: { filename: "foo.png", url_prefix: "foo/bar/${filename}" }
    end

    it 'redirects to the root path' do
      post :create, invoice: { filename: "foo.png", url_prefix: "foo/bar/${filename}" }
      expect(response).to redirect_to(root_path)
    end
  end
end
