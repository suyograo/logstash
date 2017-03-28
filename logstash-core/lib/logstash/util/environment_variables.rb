# encoding: utf-8

require "logstash/namespace"

module LogStash::Util::EnvironmentVariables
  ENV_PLACEHOLDER_REGEX = /\$\{(?<name>\w+)(\:(?<default>[^}]*))?\}/

  # Replace all environment variable references in 'value' param by environment variable value and return updated value
  # Process following patterns : $VAR, ${VAR}, ${VAR:defaultValue}
  def self.resolve(value)
    return value unless value.is_a?(String)

    value.gsub(ENV_PLACEHOLDER_REGEX) do |placeholder|
      # Note: Ruby docs claim[1] Regexp.last_match is thread-local and scoped to
      # the call, so this should be thread-safe.
      #
      # [1] http://ruby-doc.org/core-2.1.1/Regexp.html#method-c-last_match
      name = Regexp.last_match(:name)
      default = Regexp.last_match(:default)

      replacement = ENV.fetch(name, default)
      if replacement.nil?
        raise LogStash::ConfigurationError, "Cannot evaluate `#{placeholder}`. Environment variable `#{name}` is not set and there is no default value given."
      end
      replacement
    end
  end

end  