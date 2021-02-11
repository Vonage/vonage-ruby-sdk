module Vonage  
  class Voice::Builders::Connect
    attr_accessor :endpoint, :from, :eventType, :timeout, :limit, :machineDetection, :eventUrl, :eventMethod, :ringbackTone

    def initialize(**attributes)
      @endpoint = attributes.fetch(:endpoint)
      @from = attributes.fetch(:from, nil)
      @eventType = attributes.fetch(:event_type, nil)
      @timeout = attributes.fetch(:timeout, nil)
      @limit = attributes.fetch(:limit, nil)
      @machineDetection = attributes.fetch(:machine_detection, nil)
      @eventUrl = attributes.fetch(:event_url, nil)
      @eventMethod = attributes.fetch(:event_method, nil)
      @ringbackTone = attributes.fetch(:ringback_tone, nil)
    end

    def action
      create_connect!(self)
    end

    def create_connect!(builder)
      ncco = [
        {
          action: 'connect',
          endpoint: [
            create_endpoint(builder)
          ]
        }
      ]

      ncco[0].merge!(from: builder.from) if builder.from
      ncco[0].merge!(eventType: builder.eventType) if builder.eventType
      ncco[0].merge!(timeout: builder.timeout) if builder.timeout
      ncco[0].merge!(limit: builder.limit) if builder.limit
      ncco[0].merge!(machineDetection: builder.machineDetection) if builder.machineDetection
      ncco[0].merge!(eventUrl: builder.eventUrl) if builder.eventUrl
      ncco[0].merge!(eventMethod: builder.eventMethod) if builder.eventMethod
      ncco[0].merge!(ringbackTone: builder.ringbackTone) if builder.ringbackTone

      ncco
    end

    def create_endpoint(builder)
      case builder.endpoint[:type]
      when 'phone'
        phone_endpoint(builder.endpoint)
      when 'app'
        app_endpoint(builder.endpoint)
      when 'websocket'
        websocket_endpoint(builder.endpoint)
      when 'sip'
        sip_endpoint(builder.endpoint)
      when 'vbc'
        vbc_endpoint(builder.endpoint)
      else
        raise ArgumentError, "Invalid value for 'endpoint', please refer to the Vonage API Developer Portal https://developer.nexmo.com/voice/voice-api/ncco-reference#endpoint-types-and-values for a list of possible values"
      end
    end

    def phone_endpoint(endpoint_attrs)
      hash = {
        type: 'phone',
        number: endpoint_attrs[:number]
      }

      hash.merge!(dtmfAnswer: endpoint_attrs[:dtmfAnswer]) if endpoint_attrs[:dtmfAnswer]
      hash.merge!(onAnswer: endpoint_attrs[:onAnswer]) if endpoint_attrs[:onAnswer]

      hash
    end

    def app_endpoint(endpoint_attrs)
      {
        type: 'app',
        user: endpoint_attrs[:user]
      }
    end

    def websocket_endpoint(endpoint_attrs)
      hash = {
        type: 'websocket',
        uri: endpoint_attrs[:uri],
        :'content-type' => endpoint_attrs[:'content-type']
      }

      hash.merge!(headers: endpoint_attrs[:headers]) if endpoint_attrs[:headers]
    end

    def sip_endpoint(endpoint_attrs)
      hash = {
        type: 'sip',
        uri: endpoint_attrs[:uri]
      }

      hash.merge!(headers: endpoint_attrs[:headers]) if endpoint_attrs[:headers]
    end

    def vbc_endpoint(endpoint_attrs)
      {
        type: 'vbc',
        extension: endpoint_attrs[:extension]
      }
    end
  end

  class Voice::Builders::Conversation
  end

  class Voice::Builders::Input
  end

  class Voice::Builders::Notify
  end

  class Voice::Builders::Record
  end

  class Voice::Builders::Stream
  end

  class Voice::Builders::Talk
  end

  class Voice::Builders::Ncco
    ACTIONS = {
      connect: Vonage::Voice::Builders::Connect,
      conversation: Vonage::Voice::Builders::Conversation,
      input: Vonage::Voice::Builders::Input,
      notify: Vonage::Voice::Builders::Notify,
      record: Vonage::Voice::Builders::Record,
      stream: Vonage::Voice::Builders::Stream,
      talk: Vonage::Voice::Builders::Talk
    }

    ACTIONS.keys.each do |method|
      self.class.send :define_method, method do |attributes|
        ACTIONS[method].new(**attributes).action
      end
    end
  end
end