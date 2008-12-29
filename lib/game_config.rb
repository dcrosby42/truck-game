class GameConfig
  def initialize
    @config = YAML.load_file(APP_ROOT + "/config/game_config.yml")
    @config.keys.each do |prop|
      self.class.class_eval do
        define_method prop do
          @config[prop]
        end
      end
    end
  end
end
