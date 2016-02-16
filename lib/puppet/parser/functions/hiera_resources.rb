# hiera_resources - A Hiera wrapper for Puppet's create_resources function
#
require 'puppet/version'

Puppet::Parser::Functions.newfunction(:hiera_resources) do |args|
  def error(message)
    raise Puppet::Error, message
  end

  file_name = File.basename(__FILE__, File.extname(__FILE__))

  error("%s requires 1 argument" % [file_name]) unless args.length >= 1

  defaults_keys = []

  if args[1]
    error("%s expects a hash as the 2nd argument; got %s" % [file_name, args[1].class]) unless args[1].is_a? Hash

    # Get a list of keys from args[1]
    defaults_keys = args[1].keys
  end

  if Puppet.version =~ /^4/
    call_function('hiera_hash', args).each do |type, resources|
      resources.each do |title, parameter|
        if parameter == nil
          resources[title] = {}
        end

        # Check if we need to add defaults for this resource type
        if defaults_keys.include?(type)
          resources[title].merge!(args[1][type])
        end
      end
      # function_create_resources is no workie so we'll do this
      method = Puppet::Parser::Functions.function :create_resources
      send(method, [type, resources])
    end
  else
    function_hiera_hash(args).each do |type, resources|
      # Allow resources without parameters (aka default parameters)
      resources.each do |title, parameter|
        if parameter == nil
          resources[title] = {}
        end
        
        # Check if we need to add defaults for this resource type
        if defaults_keys.include?(type)
          resources[title].merge!(args[1][type])
        end
      end
      # function_create_resources is no workie so we'll do this
      method = Puppet::Parser::Functions.function :create_resources
      send(method, [type, resources])
    end
  end
end
