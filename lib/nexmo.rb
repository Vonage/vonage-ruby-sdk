# frozen_string_literal: true
require 'zeitwerk'

module Nexmo
  class ZeitwerkInflector < Zeitwerk::Inflector
    def camelize(basename, _abspath)
      case basename
      when 'http', 'json', 'jwt', 'sms', 'tfa'
        basename.upcase
      when 'applications_v2'
        'ApplicationsV2'
      when 'call_dtmf'
        'CallDTMF'
      when 'version'
        'VERSION'
      else
        super
      end
    end
  end

  private_constant :ZeitwerkInflector

  loader = Zeitwerk::Loader.new
  loader.tag = File.basename(__FILE__, '.rb')
  loader.inflector = ZeitwerkInflector.new
  loader.push_dir(__dir__)
  loader.setup
end
