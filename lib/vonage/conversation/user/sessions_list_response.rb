# typed: true

class Vonage::Conversation::User::SessionsListResponse < Vonage::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity._embedded.sessions.each { |item| yield item }
  end
end
