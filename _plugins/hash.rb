require 'digest/md5'

module Jekyll
  module Hashify
    def hashify(input)
      input = input.first if input.is_a? Array
      Digest::MD5.hexdigest(input.strip)
    end
  end
end

Liquid::Template.register_filter(Jekyll::Hashify)
