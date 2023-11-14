# typed: true

class Vonage::Meetings::Themes::ListResponse < Vonage::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity.each { |item| yield item }
  end
end
