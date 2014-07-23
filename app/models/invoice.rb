class Invoice
  include ActiveModel::Model
  attr_accessor :url_prefix, :filename

  def initialize(url_prefix: '', filename: '')
    @url_prefix = url_prefix
    @filename = Pathname.new(filename).basename.to_s
  end

  def storage_key
    File.join(url_prefix.gsub('${filename}', ''), filename)
  end
end
