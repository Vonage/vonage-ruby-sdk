# typed: true

class Vonage::Verify2::TemplateFragments::ListResponse < Vonage::Response
  include Enumerable

  def each
    return enum_for(:each) unless block_given?

    @entity._embedded.template_fragments.each { |item| yield item }
  end
end
