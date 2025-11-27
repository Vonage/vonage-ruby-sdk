# typed: true

class Vonage::Video::Connections::ListResponse < Vonage::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity.items.each { |item| yield item }
  end
end
