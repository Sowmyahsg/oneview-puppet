require 'spec_helper'

provider_class = Puppet::Type.type(:oneview_fcoe_network).provider(:ruby)

describe provider_class do

  let(:resource) {
    Puppet::Type.type(:oneview_fcoe_network).new(
      name: 'fcoe',
      ensure: 'present',
        data:
          {
              name:                       'OneViewSDK Test FC Network',
              connectionTemplateUri:      'nil',
              vlanId:                     '300',
              type:                       'fcoe-network',
          },
    )
  }

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  it 'should be an instance of the provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_fcoe_network).provider(:ruby)
  end

  context 'given the min parameters' do

    it 'should run create' do
      expect(provider.create).to be_truthy
    end

  end


end
