# typed: ignore

class Vonage::Voice::ListResponse < Vonage::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity._embedded.calls.each { |item| yield item }
  end
end
