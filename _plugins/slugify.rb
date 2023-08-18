module Jekyll
  module Slugify
    def slugify(input)
      input = input.first if input.is_a? Array
      return '' if input.nil?

      input
        .unicode_normalize(:nfkc)
        .gsub(/[^\x00-\x7F]/n, '')
        .gsub(/[']+/, '')
        .gsub(/\W+/, ' ')
        .strip
        .downcase
        .gsub(' ', '-')
    end
  end
end

Liquid::Template.register_filter(Jekyll::Slugify)
