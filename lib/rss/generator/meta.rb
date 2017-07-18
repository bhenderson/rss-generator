class RSS::Generator::Meta
  def initialize(data)
    @data = data
  end

  def title
    @title ||= @data.fetch(:title)
  end

  def link
    @link ||= @data.fetch(:link)
  end

  def description
    @description ||= @data.fetch(:description)
  end

  def image_url
    @image_url ||= @data.fetch(:image_url)
  end

  def urls
    @urls ||= @data.fetch(:urls)
  end

end
