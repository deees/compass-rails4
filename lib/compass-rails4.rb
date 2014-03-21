require "compass-rails4/version"
require "compass-rails4/configuration"

module CompassRails4

    RAILS_4 = %r{^4.[0|1]}

    extend self

    def load_rails
      return if rails_loaded?

      rails_config_path = Dir.pwd
      until File.exists?(File.join(rails_config_path, 'config', 'environment.rb')) do
        raise 'Rails application not found' if rails_config_path == '/'
        rails_config_path = File.join(rails_config_path, '..')
      end

      require "#{rails_config_path}/config/environment"
    end

    def app
      ::Rails.application
    end

    def rails_config
      app.config
    end

    def sass_config
      load_rails
      rails_config.sass
    end

    def sprockets
      load_rails
      @sprockets ||= app.assets
    end

    def context
      load_rails
      @context ||= sprockets.context_class
    end

    def rails?
      defined?(::Rails)
    end

    def rails_loaded?
      rails? && app
    end

    def rails_version
      rails_spec = Gem.loaded_specs["railties"]
      raise "You have to require Rails before compass" unless rails_spec
      rails_spec.version.to_s
    end

    def rails4?
      rails? && version_match(RAILS_4)
    end

    def version_match(version)
      !(rails_version =~ version).nil?
    end

    def booted!
      CompassRails4.const_set(:BOOTED, true)
    end

    def booted?
      defined?(CompassRails4::BOOTED) && CompassRails4::BOOTED
    end

    def configuration
      load_rails
      config = Compass::Configuration::Data.new('rails')
      config.extend(Configuration::AssetPipeline)
      config
    end

    def env
      env_production? ? :production : :development
    end

    def prefix
      rails_config.assets.prefix
    end

    def env_production?
      rails? && ::Rails.env.production?
    end

    def root
      @root ||= rails? ? ::Rails.root : Pathname.new(Dir.pwd)
    end

    def check_for_double_boot!
      if booted?
        Compass::Util.compass_warn("Warning: Compass was booted twice. Compass-rails4 has got your back; please remove your compass initializer.")
      else
        booted!
      end
    end

    def configure_rails!(app)
      return unless app.config.respond_to?(:sass)
      sass_config = app.config.sass
      compass_config = app.config.compass

      sass_config.load_paths.concat(compass_config.sass_load_paths)

      { :output_style => :style,
        :line_comments => :line_comments,
        :cache => :cache,
        :disable_warnings => :quiet,
        :preferred_syntax => :preferred_syntax
      }.each do |compass_option, sass_option|
        set_maybe sass_config, compass_config, sass_option, compass_option
      end
      if compass_config.sass_options
        compass_config.sass_options.each do |config, value|
          sass_config.send("#{config}=", value)
        end
      end
    end

    def boot_config
      config = if (config_file = Compass.detect_configuration_file) && (config_data = Compass.configuration_for(config_file))
        config_data
      else
        Compass::Configuration::Data.new("compass_rails_boot")
      end
      config.top_level.project_type = :rails
      config
    end

  private

    # sets the sass config value only if the corresponding compass-based setting
    # has been explicitly set by the user.
    def set_maybe(sass_config, compass_config, sass_option, compass_option)
      if compass_value = compass_config.send(:"#{compass_option}_without_default")
        sass_config.send(:"#{sass_option}=", compass_value)
      end
    end

end

require "compass-rails4/railtie"

Compass::AppIntegration.register(:rails, "::CompassRails4")
Compass.add_configuration(CompassRails4.boot_config)
