################################################################################
# (C) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
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

Puppet::Type.newtype(:oneview_firmware_bundle) do
  desc "Oneview's Firmware Bundle"

  ensurable do
    defaultvalues
    # :nocov:
    # Get Methods
    newvalue(:found) do
      provider.found
    end
    # :nocov:
  end

  newparam(:name, namevar: true) do
    desc 'Firmware Bundle name'
  end

  newparam(:data) do
    desc 'Firmware Bundle data hash containing the path to the bundle'
    validate do |value|
      raise Puppet::Error, 'Inserted value for data is not valid' unless value.class == Hash
    end
  end

  validate do
    raise 'A data hash parameter is required' if self[:data].nil?
  end
end
