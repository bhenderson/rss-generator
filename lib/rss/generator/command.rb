require 'rss/generator'
require 'yaml'

class RSS::Generator::Command
  def self.run(args)
    meta = YAML.load_file 'channel.yml'
    rg = RSS::Generator.new meta
    puts rg.to_xml
  end
end
