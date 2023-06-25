# typed: true
# frozen_string_literal: true

require 'net/http/post/multipart'

module Vonage
  class ProactiveConnect::Items < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.host = :vonage_host

    def list(list_id:, **params)
      path = "/v0.1/bulk/lists/#{list_id}/items"
      path += "?#{Params.encode(params)}" unless params.empty?

      request(path, response_class: ListResponse)
    end

    def download_csv(list_id:, order: 'asc', **params)
      response = request("/v0.1/bulk/lists/#{list_id}/items/download?order=#{order}", response_class: FileResponse)

      response.filename = params[:filename] if params[:filename]
      response.save(filepath: params[:filepath]) if params[:filepath]

      response
    end

    def upload_csv(list_id:, filepath:)
      pn = Pathname.new(filepath)
      raise ArgumentError, ':filepath not for a file' unless pn.file?
      raise ArgumentError, 'file at :filepath not readable' unless pn.readable?
      raise ArgumentError, 'file at :filepath not csv' unless pn.extname == '.csv'

      multipart_post_request("/v0.1/bulk/lists/#{list_id}/items/import", filepath: filepath, file_name: pn.basename, mime_type: 'text/csv')
    end

    private

    def multipart_post_request(path, filepath:, file_name:, mime_type:, response_class: Response)
      uri = URI('https://' + @host + path)

      response = File.open(filepath) do |file|
        req = Net::HTTP::Post::Multipart.new(
          uri,
          {file: Multipart::Post::UploadIO.new(file, mime_type, file_name)}
        )
        # authentication.update(req)
        req['Authorization'] = 'Bearer ' + @config.token

        # set other headers

        @http.request(req)
      end

      parse(response, response_class)
    end
  end
end
