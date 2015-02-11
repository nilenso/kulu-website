class InvoiceStates
  class << self
    def all
      KuluService::API.new.list_of_states
    end
  end
end
