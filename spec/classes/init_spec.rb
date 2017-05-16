require 'spec_helper'


describe 'tuned', :type => :class do
  context "on a CentoOS 7 OS" do
    let(:facts) do
      {
        :osfamily                  => 'RedHat',
        :operatingsystemmajrelease => '7',
        :operatingsystemrelease    => '7.0.1406',
        :operatingsystem           => 'CentOS',
      }
    end

    context 'with default values for all parameters' do
      it { should create_class('tuned') }
      it { should compile }
      it { should contain_file('/etc/tuned/bootcmdline') }
      it { should contain_file('/etc/tuned/tuned-main.conf') }
      it { should contain_service('tuned').with(
        :enable => true,
        :ensure => 'running',
        :name   => 'tuned',
      )}

      it { should contain_package('tuned').with(
        :ensure => 'present'
      )}

      it { should_not contain_class('tuned::profile::enable_profile') }
    end

    context 'with service_ensure => stopped' do
      let(:params) { { :service_ensure => 'stopped' } }
      it { should contain_service('tuned').with(
        :enable => true,
        :ensure => params[:service_ensure],
        :name   => 'tuned',
      )}
    end

    context 'with tuned_ensure => absent' do
      let(:params) { { :tuned_ensure => 'absent' } }
      it { should contain_package('tuned').with(
        :ensure => params[:tuned_ensure],
      )}
    end

    context 'with active_profile => virtual-guest' do
      let(:params) { { :active_profile => 'virtual-guest' } }
      it { should contain_class('tuned::profile::enable_profile').with(
        :profile_name => params[:active_profile],
      )}

      it { should contain_exec("tuned-adm_enable_profile_#{params[:active_profile]}").with(
        :command => "tuned-adm profile #{params[:active_profile]}",
        :unless  => "grep -q -e '^#{params[:active_profile]}\$' /etc/tuned/active_profile",
      )}
    end
  end
end
