require "logstash/namespace"
require "logstash/logging"
require "logstash/errors"
require 'clamp'
require 'logstash/pluginmanager'
require 'logstash/pluginmanager/util'
require 'rubygems/uninstaller'

class LogStash::PluginManager::Uninstall < Clamp::Command

  parameter "PLUGIN", "plugin name"

  public
  def execute

    ::Gem.configuration.verbose = false

    plugin_name = LogStash::PluginManager::Util.append_prefix(plugin)
    puts ("Validating removal of #{plugin_name}.")
    
    unless gem_data = LogStash::PluginManager::Util.logstash_plugin?(plugin_name)
      $stderr.puts ("Trying to remove a non logstash plugin. Aborting")
      return 99
    end

    puts ("Uninstalling plugin '#{plugin_name}' with version '#{gem_data.version}'.")
    ::Gem::Uninstaller.new(plugin_name, {}).uninstall
    return 
  end

end # class Logstash::PluginManager
