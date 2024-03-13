# typed: true

class Vonage::Conversation::Event::ListResponse < Vonage::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity._embedded.each { |item| yield item }
  end
end
