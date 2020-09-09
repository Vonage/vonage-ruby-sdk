# typed: ignore

class Vonage::Numbers::ListResponse < Vonage::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity.numbers.each { |item| yield item }
  end
end
