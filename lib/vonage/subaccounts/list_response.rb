# typed: true

class Vonage::Subaccounts::ListResponse < Vonage::Response
  include Enumerable

  def primary_account
    @entity._embedded.primary_account
  end

  def each
    return enum_for(:each) unless block_given?

    @entity._embedded.subaccounts.each { |item| yield item }
  end
end
