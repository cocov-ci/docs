require 'uri'
require 'net/http'
require 'base64'

module Jekyll
  class MermaidBlock < Liquid::Block
    def cache
      @@cache ||= Jekyll::Cache.new("Jekyll::Cocov::MermaidBlock")
    end

    BASE_PATH = "assets/images/diagrams"

    def render(context)
      contents = super
      id = Digest::SHA1.hexdigest(contents)
      FileUtils.mkdir_p BASE_PATH
      target_file = File.join(BASE_PATH, "#{id}.svg")
      unless File.exist? target_file
        svg = cache.getset(id) do
          data = Base64.urlsafe_encode64(contents, padding: false)
          uri = URI("https://mermaid.ink/svg/#{data}")
          res = Net::HTTP.get_response(uri)
          unless res.is_a?(Net::HTTPSuccess)
            raise RuntimeError, "Failed to perform mermaid.ink request: #{res.body}"
          end
          res.body
        end
        File.write(target_file, svg)
      end
      "<img src=\"/#{target_file}\" alt=\"A Mermaid Diagram\" />"
    end
  end
end

Liquid::Template.register_tag('mermaid', Jekyll::MermaidBlock)
