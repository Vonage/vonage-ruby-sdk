# typed: true

class Vonage::Meetings::Sessions::ListResponse < Vonage::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity._embedded.recordings.each { |item| yield item }
  end
end
