# typed: true

class Vonage::ProactiveConnect::Events::ListResponse < Vonage::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity._embedded.events.each { |item| yield item }
  end
end
