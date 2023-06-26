# typed: true

class Vonage::ProactiveConnect::Items::FileResponse < Vonage::Response
  DEFAULT_FILENAME = 'download.csv'

  attr_accessor :filename

  def initialize(entity=nil, http_response=nil)
    super
    self.filename = initial_filename
  end

  def save(filepath:)
    pn = Pathname.new(filepath)
    raise ArgumentError, ':filepath not a directory' unless pn.directory?
    raise ArgumentError, ':filepath not absolute' unless pn.absolute?
    raise ArgumentError, ':filepath not writable' unless pn.writable?

    File.open("#{pn.cleanpath}/#{filename}", 'w') {|f| f.write(http_response.body) }
  end

  def data
    http_response ? http_response.body : nil
  end

  private

  def initial_filename
    match_data = http_response['Content-Disposition'].match(/filename=(\"?)(.+)\1/)
    match_data ? match_data[2] : DEFAULT_FILENAME
  end
end
