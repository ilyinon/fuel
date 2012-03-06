require 'spec_helper'

describe 'swift::storage' do
  # TODO I am not testing the upstart code b/c it should be temporary

  describe 'when required classes are specified' do
    let :pre_condition do
      "class { 'swift': swift_hash_suffix => 'changeme' }
       include ssh::server::install
      "
    end

    describe 'when the local net ip is specified' do
      let :params do
        {
          :storage_local_net_ip => '127.0.0.1',
        }
      end

      ['xfsprogs', 'parted'].each do |present_package|
        it { should contain_package(present_package).with_ensure('present') }
      end

      it { should contain_class('rsync::server').with(
        {:use_xinetd => false,
         :address    => params[:storage_local_net_ip]
        }
      )}
    end
    describe 'when local net ip is not specified' do
      it 'should fail' do
        expect do
          subject
        end.should raise_error(Puppet::Error, /Must pass storage_local_net_ip/)
      end
    end
  end
  describe 'when the dependencies are not specified' do
    it 'should fail' do
      expect { subject }.should raise_error(Puppet::Error)
    end
  end
end
