################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'login'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'common'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'fcoe_network'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_fcoe_network).provide(:ruby) do

  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::FCoENetwork.get_all(@client)
    matches.collect do |line|
      # Puppet.notice("FCoE Network: #{line['name']}, URI: #{line['uri']}")
      name = line['name']
      data = line.inspect
      new(:name   => name,
          :ensure => :present,
          :data   => data
          )
    end
  end

  def self.prefetch(resources)
    packages = instances
    resources.keys.each do |name|
      if provider = packages.find{ |pkg| pkg.name == name }
        resources[name].provider = provider
      end
    end
  end

  # Provider methods

  def exists?
    # Gets the desired operation to perform
    state = resource['ensure'].to_s

    # Verify ensure flag and sets environment flags for operations
    case state
      when 'present' then
        # Resource itself sends the name of the running proccess
        fcoe_network = get_fcoe_network(resource['data']['name'])
        fcoe_network_exists = false
        fcoe_network_exists = true if fcoe_network.first
        # Checking for and performing potential updates.
        if fcoe_network_exists
          Puppet.notice("#{resource} '#{resource['data']['name']}' located"+
          " in Oneview Appliance")
          fcoe_network_update(resource['data'], fcoe_network, resource)
          return true
        end
      when 'absent' then
        # Resource itself sends the name of the running proccess
        fcoe_network = get_fcoe_network(resource['data']['name'])
        fcoe_network_exists = false
        fcoe_network_exists = true if fcoe_network.first
        Puppet.notice("#{resource} '#{resource['data']['name']}' not located"+
        " in Oneview Appliance") if fcoe_network_exists == false
        return fcoe_network_exists
      when 'found' then
        fcoe_network = find_fcoe_networks(resource['data'])
        fcoe_network_exists = false
        fcoe_network_exists = true if fcoe_network
        return fcoe_network_exists
    end
    @property_hash[:ensure] == :present
  end

  def create
    data = data_parse(resource['data'])
    data.delete('new_name') if data['new_name']
    fcoe_network = OneviewSDK::FCoENetwork.new(@client, data)
    fcoe_network.create
    @property_hash[:ensure] = :present
    @property_hash[:data] = data
  end

  def destroy
    fcoe_network = get_fcoe_network(resource['data']['name'])
    fcoe_network.first.delete
    @property_hash.clear
  end

  def found
    # Searches networks with data matching the manifest data
    data = data_parse(resource['data'])
    data.delete('connectionTemplateUri') if data['connectionTemplateUri'] == nil
    matches = OneviewSDK::FCoENetwork.find_by(@client, data)
    # If matches are found, iterate through them and notify. Else just notify.
    unless matches.empty?
       matches.each { |network| Puppet.notice ( "\n\n Found matching network "+
      "#{network['name']} (URI: #{network['uri']}) on Oneview Appliance\n" ) }
      true
    else
      Puppet.notice("\n\n No networks with the specified data were found on the "+
      " Oneview Appliance\n")
      false
    end
  end

end