class InvoiceDecorator < Draper::Decorator
  delegate :id, :attachment_url, :name, :date, :amount, :currency

  def attachment_url
    object.attachment_url || helpers.asset_path('placeholder-portrait-450x600.jpg')
  end

  def name
    object.name || '-'
  end

  def date
    d = object.date

    if d.blank?
      '-'
    else
      Time.parse(d).to_formatted_s(:long_ordinal)
    end
  end

  def amount_with_currency
    c = object.currency
    a = object.amount

    if c.blank? or a.blank?
      '-'
    else
      money = Money.new(a, c)
      "#{money.symbol}#{money.amount}"
    end
  end
end
