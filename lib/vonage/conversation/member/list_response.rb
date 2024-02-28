# typed: true

class Vonage::Conversation::Member::ListResponse < Vonage::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity._embedded.members.each { |item| yield item }
  end
end
