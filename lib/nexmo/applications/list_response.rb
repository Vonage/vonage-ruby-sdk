# typed: ignore

class Nexmo::Applications::ListResponse < Nexmo::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity._embedded.applications.each { |item| yield item }
  end
end
