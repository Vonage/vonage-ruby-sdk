# typed: true

class Vonage::Subaccounts::BalanceTransfers::ListResponse < Vonage::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity._embedded.balance_transfers.each { |item| yield item }
  end
end
