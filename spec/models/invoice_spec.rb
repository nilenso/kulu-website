require 'rails_helper'

RSpec.describe Invoice, :type => :model do
  context 'new' do
    it 'builds the storage_key' do
      invoice = Invoice.new('/foo/bar/${filename}', 'filename.png')
      expect(invoice.storage_key).to eq('/foo/bar/filename.png')
    end
  end

  context 'create' do
    it 'should populate errors if the service calls fails' do
      allow_any_instance_of(KuluService::API).to receive(:create_invoice) { raise HTTPService::Error.new(200, '') }
      invoice = Invoice.create('/foo/bar/${filename}', 'filename.png')
      expect(invoice.errors).to_not be_empty
    end

    it 'builds a new Invoice object' do
      allow_any_instance_of(KuluService::API).to receive(:create_invoice)
      expect(Invoice.create('/foo/bar/${filename}', 'filename.png')).to be_a_kind_of(Invoice)
    end
  end
end
