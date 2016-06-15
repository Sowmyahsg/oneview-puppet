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

require 'spec_helper'

provider_class = Puppet::Type.type(:oneview_logical_enclosure).provider(:ruby)

describe provider_class do

  let(:resource) {
    Puppet::Type.type(:oneview_logical_enclosure).new(
      name: 'Test Logical Enclosure',
    ensure: 'present',
        data:
          {
              'name'                    => 'Encl1',
              'type'                    => 'LogicalEnclosure'
          },
    )
  }

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_logical_enclosure).provider(:ruby)
  end

  context 'given the minimum parameters' do

    # it 'exists? should return false at first' do
    #   expect(provider.exists?).not_to be
    # end
    #
    # it 'found should return false at first' do
    #   expect(provider.found).not_to be
    # end
    #
    # it 'should create a new logical enclosure' do
    #   expect(provider.create).to be
    # end
    #
    # it 'exists? should find a logical enclosure' do
    #   expect(provider.exists?).to be
    # end
    # 
    # it 'should not be able to run destroy' do
    #   expect(provider.destroy).not_to be
    # end

  end

end
