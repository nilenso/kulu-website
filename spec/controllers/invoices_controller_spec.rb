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

  context "GET show" do
    let(:invoice_result) {
      {
        "id" => "df56565f-7a24-4701-9ac9-f29235a1f00e",
        "name" => "Invoice #1",
      }
    }

    it "fetches the invoice" do
      expect_any_instance_of(KuluService::API).to receive(:find_invoice).with("df56565f-7a24-4701-9ac9-f29235a1f00e").and_return(invoice_result)
      get :show, id: "df56565f-7a24-4701-9ac9-f29235a1f00e"
      invoice = assigns(:invoice)
      expect(invoice.name).to eq("Invoice #1")
    end
  end
end
