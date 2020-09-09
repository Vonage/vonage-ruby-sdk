# typed: ignore

module Vonage
  module GSM7
    CHARACTERS = "\n\f\r !\"\#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_abcdefghijklmnopqrstuvwxyz{|}~ ¡£¤¥§¿ÄÅÆÉÑÖØÜßàäåæçèéìñòöøùüΓΔΘΛΞΠΣΦΨΩ€"

    REGEXP = /\A[#{Regexp.escape(CHARACTERS)}]*\z/

    def self.encoded?(string)
      REGEXP =~ string
    end
  end
end
