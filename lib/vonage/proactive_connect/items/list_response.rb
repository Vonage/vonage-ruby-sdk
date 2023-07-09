# typed: true

class Vonage::ProactiveConnect::Items::ListResponse < Vonage::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity._embedded.items.each { |item| yield item }
  end
end
