require 'spec_helper'

describe 'duplicity::profile' do
  let(:title) { 'default' }
  let(:default_config_file) { '/etc/duply/default/conf' }

  describe 'by default' do
    let(:params) { {} }

    it { should contain_file('/etc/duply/default').with_ensure('directory') }
    it { should contain_file('/etc/duply/default/conf').with_ensure('file') }
    it { should contain_file('/etc/duply/default/exclude').with_ensure('file') }
  end

  describe 'with ensure absent' do
    let(:params) { {:ensure => 'absent'} }

    it { should contain_file('/etc/duply/default').with_ensure('absent') }
    it { should contain_file('/etc/duply/default/conf').with_ensure('absent') }
    it { should contain_file('/etc/duply/default/exclude').with_ensure('absent') }
  end

  describe 'with invalid ensure' do
    let(:params) { {:ensure => 'foobar'} }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /ensure/)
    end
  end

  describe 'with invalid encryption_keys' do
    let(:params) { {:encryption_keys => 'foobar'} }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /encryption_keys/)
    end
  end

  describe 'with empty encryption_keys' do
    let(:params) { {:encryption_keys => []} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC=''$/) }
  end

  describe 'with encryption_keys => [key1]' do
    let(:params) { {:encryption_keys => ['key1']} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC='key1'$/) }
  end

  describe 'with encryption_keys => [key1,key2]' do
    let(:params) { {:encryption_keys => ['key1', 'key2']} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC='key1,key2'$/) }
  end
end