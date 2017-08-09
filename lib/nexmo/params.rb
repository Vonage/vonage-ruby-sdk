require 'cgi'

module Nexmo
  module Params
    def self.encode(params)
      params.flat_map { |k, vs| Array(vs).map { |v| "#{escape(k)}=#{escape(v)}" } }.join('&')
    end

    private

    def self.escape(component)
      CGI.escape(component.to_s)
    end
  end
end
