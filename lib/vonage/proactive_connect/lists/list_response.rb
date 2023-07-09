# typed: true

class Vonage::ProactiveConnect::Lists::ListResponse < Vonage::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity._embedded.lists.each { |item| yield item }
  end
end
