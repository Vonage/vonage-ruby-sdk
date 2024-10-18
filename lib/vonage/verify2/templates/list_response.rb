# typed: true

class Vonage::Verify2::Templates::ListResponse < Vonage::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity._embedded.templates.each { |item| yield item }
  end
end
