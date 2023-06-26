# typed: true
# frozen_string_literal: true

module Vonage
  class Verify2::WorkflowBuilder

    def self.build
      builder = self.new
      yield builder if block_given?
      builder.workflow
    end

    attr_reader :workflow

    def initialize
      @workflow = Vonage::Verify2::Workflow.new
    end

    Vonage::Verify2::Workflow::CHANNELS.keys.each do |channel|
      define_method "add_#{channel.to_s}" do |args|
        workflow << workflow.send(channel, **args)
      end
    end
  end
end
