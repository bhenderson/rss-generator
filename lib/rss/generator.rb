module RSS; end

require 'erb'
require 'fileutils'

class RSS::Generator
  VERSION = "1.0.0"

  attr_accessor :meta

  def initialize(meta)
    @meta = Meta.new meta
  end

  def items
    return @items if defined? @items
    @items = []

    FileUtils.mkdir_p 'cache'
    Dir.chdir 'cache' do
      date = Date.today
      # reverse so last url gets newest date
      meta.urls.reverse_each do |url|
        @items << fetch(url, date)
        date -= 1
      end
    end

    @items
  end

  def to_xml
    data = File.read(__FILE__).split(/^__END__$/, 2).last
    ERB.new(data, nil, '<>').result binding
  end

  private

  def fetch(url, date)
    url.chomp!
    file_name = File.basename url
    unless test ?e, file_name
      warn "Downloading #{url}"
      # get just enough to read MP3 meta data
      `curl -r 0-204800 -sS -o #{file_name} #{url}`
    end

    Item.new file_name, url, date
  end

  def h(s)
    CGI.escapeHTML s.to_s
  end
end

require 'rss/generator/meta'
require 'rss/generator/item'

__END__
<?xml version="1.0" encoding="UTF-8"?>
<!-- This file generated by <%= self.class %> <%= VERSION %> -->
<rss xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="2.0">
  <channel>
    <title><%= h meta.title %></title>
    <link><%= h meta.link %></link>
    <description><%= h meta.description %></description>
    <itunes:summary><%= h meta.description %></itunes:summary>
    <generator><%= self.class %> <%= VERSION %></generator>
    <image>
      <url><%= h meta.image_url %></url>
    </image>
    <% items.each do |item| %>
    <item>
      <title><%= h item.title %></title>
      <itunes:author><%= h item.artist %></itunes:author>
      <enclosure url="<%= h item.url %>" type="audio/mp3"/>
      <guid isPermaLink="false"><%= h item.uuid %></guid>
      <pubDate><%= h item.date %></pubDate>
    </item>
    <% end %>
  </channel>
</rss>