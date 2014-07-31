require 'rails_helper'

RSpec.describe KuluService, :type => :model do
  context 'create invoice' do
    it 'makes a new invoice creation request with the given storage key' do
      expect_any_instance_of(Faraday::Connection).to receive(:post)
      KuluService.new.create_invoice(:foo)
    end
  end
end
