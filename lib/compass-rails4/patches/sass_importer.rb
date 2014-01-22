module CompassRails4
  module SassTemplate

    def self.included(base)
      base.class_eval do
        alias_method_chain :evaluate, :compass_rails
      end
    end

    def evaluate_with_compass_rails(context, locals, &block)
      # Use custom importer that knows about Sprockets Caching
      cache_store = Sprockets::SassCacheStore.new(context.environment)
      paths  = context.environment.paths.map { |path| CompassRails4::SpriteImporter.new(context, path) }
      paths += context.environment.paths.map { |path| Sprockets::SassImporter.new(context, path) }
      paths += CompassRails4.sass_config.load_paths

      options = CompassRails4.sass_config.merge( {
        :filename => eval_file,
        :line => line,
        :syntax => syntax,
        :cache_store => cache_store,
        :importer => Sprockets::SassImporter.new(context, context.pathname),
        :load_paths => paths,
        :sprockets => {
          :context => context,
          :environment => context.environment
        }
      })

      ::Sass::Engine.new(data, options).render
    rescue ::Sass::SyntaxError => e
      # Annotates exception message with parse line number
      context.__LINE__ = e.sass_backtrace.first[:line]
      raise e
    end
  end
end

Sprockets::ScssTemplate.send(:include, CompassRails4::SassTemplate)
Sprockets::SassTemplate.send(:include, CompassRails4::SassTemplate)
