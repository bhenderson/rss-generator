require 'json'
require 'securerandom'

class RSS::Generator::Item
  def initialize(name, url, date)
    @name = name
    @url = url
    @date = date
    @data = JSON.parse(`exiftool -json #{name}`).first
  end

  def title
    @data['Title'] || "Title #{date}"
  end

  def artist
    @data['Artist'] || "Artist #{date}"
  end

  def url
    @url
  end

  def uuid
    @uuid ||= SecureRandom.uuid
  end

  def date
    @date
  end
end
