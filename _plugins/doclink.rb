require_relative './doclink_parser'

module Jekyll
  class DocLink < Liquid::Tag
    DATA = YAML.load_file("_data/docs_index.yaml")
    def self.slug
      @slug ||= Class.new.extend(::Jekyll::Slugify)
    end

    def slugify(what)
      self.class.slug.slugify(what)
    end

    def initialize(tag_name, content, tokens)
      super
      parsed = DocLinkParser.new(content).parse
      @name = parsed[:link]
      @opts = parsed[:opts]
    end

    def render(context)
      n, path = get
      path.map! { |p| slugify(p) }
      n = if @opts["title"]
        @opts["title"]
      elsif n.is_a? Hash
        n["title"]
      else
        n
      end
      suffix = if @opts.key? "hash"
        "##{@opts["hash"]}"
      end


      html = <<~HTML
      <a href="/docs/#{path.join("/")}#{suffix}">#{n}</a>
      HTML

      html.strip
    end

    def extract_items(from)
      case from
      when Hash
        from["items"]
      when Array, String
        from
      end
    end

    def get
      if @name.include? "/"
        components = @name.split("/").map(&:strip)
        w = DATA["nav"]
        path = []
        until components.empty?
          cmp = components.shift
          obj, p = find(cmp, extract_items(w), path)
          if obj.nil?
            puts "Parent was #{w}, Path: #{path}, components: #{components}"
            raise ArgumentError, "Unknown page `#{@name}' (component was `#{cmp}')"
          end

          if !obj.is_a?(Hash) && !components.empty?
            raise ArgumentError, "Unknown page `#{@name}': Short find"
          end

          w = obj
          path = p
        end

        return w, path
      end

      find(@name).tap do |r|
        raise ArgumentError, "Unknown page `#{@name}'" unless r
      end
    end

    def find(what, where = DATA["nav"], path = [])
      where.each do |obj|
        case obj
        when Hash
          return [obj, path + [obj["title"]]] if obj["title"] == what
          r = find(what, obj["items"], path + [obj["title"]])
          return r unless r.nil?
        when String
          return [obj, path + [obj]] if obj == what
        end
      end

      nil
    end
  end
end

Liquid::Template.register_tag('doclink', Jekyll::DocLink)
