require 'compass-rails4/patches/compass'
require 'compass-rails4/patches/sass_importer'
require 'compass-rails4/patches/sprite_importer'

module Sass::Script::Functions
  def generated_image_url(path, only_path = nil)
    cachebust_generated_images
    asset_url(path)
  end

  def cachebust_generated_images
    generated_images_path = CompassRails4.root.join(Compass.configuration.generated_images_dir).to_s
    sprockets_entries = CompassRails4.sprockets.send(:trail).index.instance_variable_get(:@entries)
    sprockets_entries.delete(generated_images_path) if sprockets_entries.has_key? generated_images_path
  end

  def asset_url(path)
    context = CompassRails4.context.new(CompassRails4.sprockets, path.value, path.value)
    Sass::Script::String.new("url(" + context.asset_path(path.value) + ")")
  end
end

module Sass::Script::Functions
  include Compass::RailsImageFunctionPatch
end

# Wierd that this has to be re-included to pick up sub-modules. Ruby bug?
class Sass::Script::Functions::EvaluationContext
  include Sass::Script::Functions
end
