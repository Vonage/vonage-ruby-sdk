# typed: true
# frozen_string_literal: true
require 'zeitwerk'
require 'sorbet-runtime'

module Vonage
  loader = Zeitwerk::Loader.new
  loader.tag = File.basename(__FILE__, '.rb')
  loader.inflector.inflect({
    'dtmf' => 'DTMF',
    'gsm7' => 'GSM7',
    'http' => 'HTTP',
    'json' => 'JSON',
    'jwt' => 'JWT',
    'sms' => 'SMS',
    'tfa' => 'TFA',
    'version' => 'VERSION',
  })
  loader.push_dir(__dir__)
  loader.setup

  def self.config
    @config ||= Config.new
  end

  def self.configure(&block)
    block.call(config)
  end
end
