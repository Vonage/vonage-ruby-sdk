# typed: ignore

class Nexmo::Secrets::ListResponse < Nexmo::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity._embedded.secrets.each { |item| yield item }
  end
end
