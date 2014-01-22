unless CompassRails4.rails4?
  $stderr.puts "Unsupported rails environment for compass"
  exit 1
end

class Rails::Railtie::Configuration
  # Adds compass configuration accessor to the application configuration.
  #
  # If a configuration file for compass exists, it will be read in and
  # the project's configuration values will already be set on the config
  # object.
  #
  # For example:
  #
  #     module MyApp
  #       class Application < Rails::Application
  #          config.compass.line_comments = !Rails.env.production?
  #          config.compass.fonts_dir = "app/assets/fonts"
  #       end
  #     end
  #
  # It is suggested that you create a compass configuration file if you
  # want a quicker boot time when using the compass command line tool.
  #
  # For more information on available configuration options see:
  # http://compass-style.org/help/tutorials/configuration-reference/
  def compass
    @compass ||= begin
      data = if (config_file = Compass.detect_configuration_file) && (config_data = Compass.configuration_for(config_file))
        config_data
      else
        Compass::Configuration::Data.new("rails_config")
      end
      data.project_type = :rails # Forcing this makes sure all the rails defaults will be loaded.

      Compass.add_configuration(:rails)
      Compass.add_configuration(data)

      data
    end
    @compass
  end
end

module CompassRails4
  class Railtie < ::Rails::Railtie
    initializer "compass.initialize_rails", :group => :all do |app|
      require 'compass-rails4/patches'
      # Configure compass for use within rails, and provide the project configuration
      # that came via the rails boot process.
      CompassRails4.check_for_double_boot!
      Compass.discover_extensions!
      CompassRails4.configure_rails!(app)
    end
  end
end
