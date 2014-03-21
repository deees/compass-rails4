module CompassRails4
  module Configuration
    module AssetPipeline

      def default_images_dir
        File.join("app", "assets", "images")
      end

      def default_fonts_dir
        File.join("app", "assets", "fonts")
      end

      def default_javascripts_dir
        File.join("app", "assets", "javascripts")
      end

      def default_css_dir
        File.join('public', CompassRails4.prefix)
      end

      def default_http_path
        File.join(CompassRails4.prefix)
      end

      def default_http_images_path
        "#{top_level.http_path}"
      end

      def default_http_javascripts_path
        "#{top_level.http_path}"
      end

      def default_http_fonts_path
        "#{top_level.http_path}"
      end

      def default_http_stylesheets_path
        "#{top_level.http_path}"
      end

      def default_preferred_syntax
        CompassRails4.sass_config.preferred_syntax rescue nil
      end

      def default_sprite_load_path
        CompassRails4.sprockets.paths
      end

    end
  end
end
