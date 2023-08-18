module Jekyll
  class NoticeBlock < Liquid::Block
    def initialize(tag_name, variable_name, options)
      super
      @name = tag_name
    end

    def render(context)
      site = context.registers[:site]
      converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
      output = converter.convert(super(context))
      "<div class=\"notice #{@name}\"><div class=\"notice-wrapper\">#{output}</div></div>"
    end
  end
end

Liquid::Template.register_tag('warning', Jekyll::NoticeBlock)
Liquid::Template.register_tag('info', Jekyll::NoticeBlock)
