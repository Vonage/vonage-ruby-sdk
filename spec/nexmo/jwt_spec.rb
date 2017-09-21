require 'minitest/autorun'
require 'nexmo'

describe 'Nexmo::JWT' do
  describe 'auth_token method' do
    it 'returns the payload encoded with the private key' do
      time = Time.now.to_i

      payload = {
        'application_id' => application_id,
        'iat' => time,
        'exp' => time + 3600,
        'jti' => 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      }

      encoded_token = Nexmo::JWT.auth_token(payload, private_key)

      decode(encoded_token).must_equal(payload)
    end

    it 'sets a default value for the iat parameter' do
      encoded_token = Nexmo::JWT.auth_token({}, private_key)

      decode(encoded_token).fetch('iat').must_be_kind_of(Integer)
    end

    it 'sets a default value for the exp parameter' do
      encoded_token = Nexmo::JWT.auth_token({}, private_key)

      decode(encoded_token).fetch('exp').must_be_kind_of(Integer)
    end

    it 'sets a default value for the jti parameter' do
      encoded_token = Nexmo::JWT.auth_token({}, private_key)

      decode(encoded_token).fetch('jti').must_match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)
    end
  end

  private

  def decode(encoded_token)
    JWT.decode(encoded_token, private_key, verify=true, {algorithm: 'RS256'}).first
  end

  def application_id
    @application_id ||= SecureRandom.uuid
  end

  def private_key
    @private_key ||= OpenSSL::PKey::RSA.new(1024)
  end
end
