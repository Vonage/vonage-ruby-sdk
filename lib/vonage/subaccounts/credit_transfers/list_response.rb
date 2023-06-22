# typed: true

class Vonage::Subaccounts::CreditTransfers::ListResponse < Vonage::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity._embedded.credit_transfers.each { |item| yield item }
  end
end
