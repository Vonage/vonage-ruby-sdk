# typed: strong

module Vonage
  module GSM7
    extend T::Sig
    
    CHARACTERS = "\n\f\r !\"\#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_abcdefghijklmnopqrstuvwxyz{|}~ ¡£¤¥§¿ÄÅÆÉÑÖØÜßàäåæçèéìñòöøùüΓΔΘΛΞΠΣΦΨΩ€"

    REGEXP = /\A[#{Regexp.escape(CHARACTERS)}]*\z/

    sig { params(string: T.nilable(String)).returns(T.nilable(Integer)) }
    def self.encoded?(string)
      REGEXP =~ string
    end
  end
end
