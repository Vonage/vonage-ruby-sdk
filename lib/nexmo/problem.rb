# frozen_string_literal: true
require 'json'

module Nexmo
  module Problem
    extend self

    def parse(body)
      problem = ::JSON.parse(body)

      title = problem['title']

      detail = problem['detail']

      url = problem['type']

      "#{title}. #{detail} See #{url} for more info, or email support@nexmo.com if you have any questions."
    end
  end

  private_constant :Problem
end
