require 'spec_helper'


describe 'tuned::profile', :type => :define do
  let(:title) { 'mongodb' }
  let(:pre_condition) { 'include ::tuned' }

  context "on a CentoOS 7 OS" do
    let(:facts) do
      {
        :osfamily                  => 'RedHat',
        :operatingsystemmajrelease => '7',
        :operatingsystemrelease    => '7.0.1406',
        :operatingsystem           => 'CentOS',
      }
    end

    context 'create simple profile without scripts' do
      let(:params) {
        {
          :conf_content => 'mycontent'
        }
      }

      it { should contain_file('/etc/tuned/mongodb').with(
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      )}

      it { should contain_file('/etc/tuned/mongodb/tuned.conf').with(
        'ensure'  => 'file',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => params[:conf_content],
      )}

      it { should_not contain_define('tuned::profile::create_script') }
    end

    context 'create profile with scripts' do
      let(:params) {
        {
          :scripts => {
            'script1.sh' => "content1",
            'script2.sh' => "content2",
          }
        }
      }

      it { should contain_file('/etc/tuned/mongodb/script1.sh').with(
        'ensure'  => 'file',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
        'content' => 'content1',
      )}

      it { should contain_file('/etc/tuned/mongodb/script2.sh').with(
        'ensure'  => 'file',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
        'content' => 'content2',
      )}
    end
  end
end
