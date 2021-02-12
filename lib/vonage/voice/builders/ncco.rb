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

      hash
    end

    def sip_endpoint(endpoint_attrs)
      hash = {
        type: 'sip',
        uri: endpoint_attrs[:uri]
      }

      hash.merge!(headers: endpoint_attrs[:headers]) if endpoint_attrs[:headers]

      hash
    end

    def vbc_endpoint(endpoint_attrs)
      {
        type: 'vbc',
        extension: endpoint_attrs[:extension]
      }
    end
  end

  class Voice::Builders::Conversation
    attr_accessor :name, :musicOnHoldUrl, :startOnEnter, :endOnExit, :record, :canSpeak, :canHear, :mute

    def initialize(**attributes)
      @name = attributes.fetch(:name)
      @musicOnHoldUrl = attributes.fetch(:musicOnHoldUrl, nil)
      @startOnEnter = attributes.fetch(:startOnEnter, nil)
      @endOnExit = attributes.fetch(:endOnExit, nil)
      @record = attributes.fetch(:record, nil)
      @canSpeak = attributes.fetch(:canSpeak, nil)
      @canHear = attributes.fetch(:canHear, nil)
      @mute = attributes.fetch(:mute, nil)
    end

    def action
      create_conversation!(self)
    end

    def create_conversation!(builder)
      ncco = [
        {
          action: 'conversation',
          name: builder.name
        }
      ]

      ncco[0].merge!(musicOnHoldUrl: builder.musicOnHoldUrl) if (builder.musicOnHoldUrl || builder.musicOnHoldUrl == false)
      ncco[0].merge!(startOnEnter: builder.startOnEnter) if (builder.startOnEnter || builder.startOnEnter == false)
      ncco[0].merge!(endOnExit: builder.endOnExit) if (builder.endOnExit || builder.endOnExit == false)
      ncco[0].merge!(record: builder.record) if builder.record
      ncco[0].merge!(canSpeak: builder.canSpeak) if builder.canSpeak
      ncco[0].merge!(canHear: builder.canHear) if builder.canHear
      ncco[0].merge!(mute: builder.mute) if builder.mute

      ncco
    end
  end

  class Voice::Builders::Input
    attr_accessor :type, :dtmf, :speech, :eventUrl, :eventMethod

    def initialize(**attributes)
      @type = attributes.fetch(:type)
      @dtmf = attributes.fetch(:dtmf, nil)
      @speech = attributes.fetch(:speech, nil)
      @eventUrl = attributes.fetch(:eventUrl, nil)
      @eventMethod = attributes.fetch(:eventMethod, nil)
    end

    def action
      create_input!(self)
    end

    def create_input!(builder)
      ncco = [
        {
          action: 'input',
          type: builder.type
        }
      ]

      ncco[0].merge!(dtmf: builder.dtmf) if builder.dtmf
      ncco[0].merge!(speech: builder.speech) if builder.speech
      ncco[0].merge!(eventUrl: builder.eventUrl) if builder.eventUrl
      ncco[0].merge!(eventMethod: builder.eventMethod) if builder.eventMethod

      ncco
    end
  end

  class Voice::Builders::Notify
    attr_accessor :payload, :eventUrl, :eventMethod

    def initialize(**attributes)
      @payload = attributes.fetch(:payload)
      @eventUrl = attributes.fetch(:eventUrl)
      @eventMethod = attributes.fetch(:eventMethod, nil)
    end

    def action
      create_notify!(self)
    end

    def create_notify!(builder)
      ncco = [
        {
          action: 'notify',
          payload: builder.payload,
          eventUrl: builder.eventUrl
        }
      ]

      ncco[0].merge!(eventMethod: builder.eventMethod) if builder.eventMethod

      ncco
    end
  end

  class Voice::Builders::Record
    attr_accessor :format, :split, :channels, :endOnSilence, :endOnKey, :timeOut, :beepStart, :eventUrl, :eventMethod

    def initialize(**attributes)
      @format = attributes.fetch(:format, nil)
      @split = attributes.fetch(:split, nil)
      @channels = attributes.fetch(:channels, nil)
      @endOnSilence = attributes.fetch(:endOnSilence, nil)
      @endOnKey = attributes.fetch(:endOnKey, nil)
      @timeOut = attributes.fetch(:timeOut, nil)
      @beepStart = attributes.fetch(:beepStart, nil)
      @eventUrl = attributes.fetch(:eventUrl, nil)
      @eventMethod = attributes.fetch(:eventMethod, nil)
    end

    def action
      create_record!(self)
    end

    def create_record!(builder)
      ncco = [
        {
          action: 'record'
        }
      ]

      ncco[0].merge!(format: builder.format) if builder.format
      ncco[0].merge!(split: builder.split) if builder.split
      ncco[0].merge!(channels: builder.channels) if builder.channels
      ncco[0].merge!(endOnSilence: builder.endOnSilence) if builder.endOnSilence
      ncco[0].merge!(endOnKey: builder.endOnKey) if builder.endOnKey
      ncco[0].merge!(timeOut: builder.timeOut) if builder.timeOut
      ncco[0].merge!(beepStart: builder.beepStart) if builder.beepStart
      ncco[0].merge!(eventUrl: builder.eventUrl) if builder.eventUrl
      ncco[0].merge!(eventMethod: builder.eventMethod) if builder.eventMethod

      ncco
    end
  end

  class Voice::Builders::Stream
    attr_accessor :streamUrl, :level, :bargeIn, :loop

    def initialize(**attributes)
      @streamUrl = attributes.fetch(:streamUrl)
      @level = attributes.fetch(:level, nil)
      @bargeIn = attributes.fetch(:bargeIn, nil)
      @loop = attributes.fetch(:loop, nil)
    end

    def action
      create_stream!(self)
    end

    def create_stream!(builder)
      ncco = [
        {
          action: 'stream',
          streamUrl: builder.streamUrl
        }
      ]

      ncco[0].merge!(level: builder.level) if builder.level
      ncco[0].merge!(bargeIn: builder.bargeIn) if (builder.bargeIn || builder.bargeIn == false)
      ncco[0].merge!(loop: builder.loop) if builder.loop

      ncco
    end
  end

  class Voice::Builders::Talk
    attr_accessor :text, :bargeIn, :loop, :level, :language, :style

    def initialize(**attributes)
      @text = attributes.fetch(:text)
      @bargeIn = attributes.fetch(:bargeIn, nil)
      @loop = attributes.fetch(:loop, nil)
      @level = attributes.fetch(:level, nil)
      @language = attributes.fetch(:language, nil)
      @style = attributes.fetch(:style, nil)
    end

    def action
      create_talk!(self)
    end

    def create_talk!(builder)
      ncco = [
        {
          action: 'talk',
          text: builder.text
        }
      ]

      ncco[0].merge!(bargeIn: builder.bargeIn) if (builder.bargeIn || builder.bargeIn == false)
      ncco[0].merge!(loop: builder.loop) if builder.loop
      ncco[0].merge!(level: builder.level) if builder.level
      ncco[0].merge!(language: builder.language) if builder.language
      ncco[0].merge!(style: builder.style) if builder.style

      ncco
    end
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

    def self.method_missing(method)
      raise ClientError.new("NCCO action must be one of the valid options. Please refer to https://developer.nexmo.com/voice/voice-api/ncco-reference#ncco-actions for a complete list.")
    end
  end
end