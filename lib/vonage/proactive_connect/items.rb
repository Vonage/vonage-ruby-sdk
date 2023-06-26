# typed: true
# frozen_string_literal: true

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
  end
end
