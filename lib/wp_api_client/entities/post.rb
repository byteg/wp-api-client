module WpApiClient
  module Entities
    class Post < Base
      alias :post :resource

      def self.represents?(json)
        json.dig("_links", "about") and json["_links"]["about"].first["href"] =~ /#{Regexp.escape(WpApiClient.configuration.endpoint)}\/types/
      end

      def id
        post["id"]
      end

      def banner_image_url
        post["featured_media_url"]
      end

      def title
        post["title"]["rendered"]
      end

      def date
        Time.parse(post["date_gmt"]) if post["date_gmt"]
      end

      def content
        post["content"]["rendered"]
      end

      def excerpt
        post["excerpt"]["rendered"]
      end

      def terms(taxonomy = nil)
        relations("https://api.w.org/term", taxonomy)
      end

      def author
        relations("author")
      end

      def meta(key = nil)
        @meta ||= relations("https://api.w.org/meta")

        if key
          @meta[key.to_s]
        else
          @meta
        end
      end
    end
  end
end
