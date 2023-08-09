# typed: true

class Vonage::Users::ListResponse < Vonage::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity._embedded.users.each { |item| yield item }
  end
end
