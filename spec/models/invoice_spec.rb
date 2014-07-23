require 'rails_helper'

RSpec.describe Invoice, :type => :model do
  it "builds the storage_key" do
    invoice = Invoice.new(url_prefix: "/foo/bar/${filename}", filename: "filename.png")
    expect(invoice.storage_key).to eq("/foo/bar/filename.png")
  end
end
