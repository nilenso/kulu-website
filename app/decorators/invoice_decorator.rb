class InvoiceDecorator < Draper::Decorator
  delegate_all

  def image_url
    object.image_url || helpers.asset_path('placeholder-portrait-450x600.jpg')
  end
end
