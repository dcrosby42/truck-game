require 'yaml'
require 'diy'

class SystemContext

  def get_app_starter
    main_context['app_starter']
  end
  
  def get_main_window
    main_context['main_window']
  end
  
  private
	def main_context
    if @context.nil?
      hash = YAML.load(File.read(APP_ROOT + '/config/objects.yml'))
      
      @context = DIY::Context.new(hash)
    end
    @context.build_everything
		@context
	end
end
