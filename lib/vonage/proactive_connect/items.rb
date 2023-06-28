# typed: true
# frozen_string_literal: true

module Vonage
  class ProactiveConnect::Items < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.host = :vonage_host

    # Find all list items
    #
    # @example
    #   response = proactive_connect.items.list(list_id: 'e546eebe-8e23-4e4d-bb7c-29d4700c9865')
    #
    # @param [required, String] :list_id
    #   Unique identifier for the list
    #
    # @param [optional, String] :page
    #   Page of results to jump to
    #
    # @param [optional, String] :page_size
    #   Number of results per page
    #
    # @param [optional, String] order
    #   Sort in either ascending (asc, the default) or descending (desc) order
    #
    # @see https://developer.vonage.com/en/api/proactive-connect#itemsFindAll
    #
    def list(list_id:, **params)
      path = "/v0.1/bulk/lists/#{list_id}/items"
      path += "?#{Params.encode(params)}" unless params.empty?

      request(path, response_class: ListResponse)
    end

    # Download list items as a CSV file format
    #
    # @example
    #   response = proactive_connect.items.download_csv(list_id: 'e546eebe-8e23-4e4d-bb7c-29d4700c9865')
    #
    # @param [required, String] :list_id
    #   ID for the list to download
    #
    # @param [optional, String] order
    #   Sort in either ascending (asc, the default) or descending (desc) order
    #
    # @param [optional, String] :filename
    #   A name to set for the returned File object. If not set, the File object will use the actual filename (if available)
    #     or a default of `download.csv` if the actual filename is not available.
    #
    # @param [optional, String] :filepath
    #   A filepath to a directory where the file should be written.
    #   If not set, the file is not written, though the the file can be written at any time by calling `save` on the returned
    #     object and passing in `:filepath` as an argument to the `save` method, for example:
    #       response = proactive_connect.items.download_csv(list_id: 'e546eebe-8e23-4e4d-bb7c-29d4700c9865')
    #       response.save('/files/downloads/')
    #   If set, the filepath must be:
    #     - An absolute path
    #     - For a valid directory
    #     - The directory must be writable
    #
    # @see https://developer.vonage.com/en/api/proactive-connect#itemsDownload
    #
    def download_csv(list_id:, order: 'asc', **params)
      response = request("/v0.1/bulk/lists/#{list_id}/items/download?order=#{order}", response_class: FileResponse)

      response.filename = params[:filename] if params[:filename]
      response.save(filepath: params[:filepath]) if params[:filepath]

      response
    end

    # Import list items from a CSV file
    #
    # @example
    #   response = proactive_connect.items.upload_csv(list_id: 'e546eebe-8e23-4e4d-bb7c-29d4700c9865', filepath: '/files/import.csv')
    #
    # @param [required, String] :list_id
    #   ID for the list to download
    #
    # @param [optional, String] order
    #   Sort in either ascending (asc, the default) or descending (desc) order
    #
    # @param [optional, String] :filename
    #   A name to set for the returned File object. If not set, the File object will use the actual filename (if available)
    #     or a default of `download.csv` if the actual filename is not available.
    #
    # @param [required, String] :filepath
    #   A filepath for the file to import. The file must be:
    #     - A valid file
    #     - Readable
    #     - Must have a `.csv` extension
    #
    # @see https://developer.vonage.com/en/api/proactive-connect#itemsImport
    #
    def upload_csv(list_id:, filepath:)
      pn = Pathname.new(filepath)
      raise ArgumentError, ':filepath not for a file' unless pn.file?
      raise ArgumentError, 'file at :filepath not readable' unless pn.readable?
      raise ArgumentError, 'file at :filepath not csv' unless pn.extname == '.csv'

      multipart_post_request("/v0.1/bulk/lists/#{list_id}/items/import", filepath: filepath, file_name: pn.basename, mime_type: 'text/csv')
    end
  end
end
