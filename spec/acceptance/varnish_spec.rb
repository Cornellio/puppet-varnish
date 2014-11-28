require 'spec_helper_acceptance'

describe 'varnish' do

  context 'with distro package (EPEL for RedHat)' do

    before :all do
      pp = <<-EOS
        $source = $::osfamily ? {
          'Debian' => 'distro',
          'RedHat' => 'epel',
        }
        class { 'varnish::repo':
          source => $source,
        }
        package { 'varnish':
          ensure => 'absent',
        } ->
        package { 'varnish-libs':
          ensure => 'absent',
        }
      EOS
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    context 'with defaults' do
      it 'should idempotently run' do
        pp = <<-EOS
        class { 'varnish':
          multi_instances => false,
        }
        EOS

        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes => true)
      end

      describe port(6081) do
        it { is_expected.to be_listening }
      end

      describe port(6082) do
        it { is_expected.to be_listening }
        it do
          pending 'serverspec documentation is abviously not up-to-date'
          is_expected.to be_listening.on('127.0.0.1').with('tcp')
        end
      end
    end
  end

  context 'with upstream package' do

    before :all do
      pp = <<-EOS
        class { 'varnish::repo': }
        package { 'varnish':
          ensure => 'absent',
        } ->
        package { 'varnish-libs':
          ensure => 'absent',
        }
      EOS
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    context 'with defaults' do
      it 'should idempotently run' do
        pp = <<-EOS
        class { 'varnish':
          multi_instances => false,
        }
        EOS

        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes => true)
      end

      describe port(6081) do
        it { is_expected.to be_listening }
      end

      describe port(6082) do
        it { is_expected.to be_listening }
        it do
          pending 'serverspec documentation is abviously not up-to-date'
          is_expected.to be_listening.on('127.0.0.1').with('tcp')
        end
      end
    end

    context 'when changing VARNISH_LISTEN_PORT' do
      it 'should idempotently run' do
        pp = <<-EOS
        class { 'varnish':
          multi_instances => false,
        }
        varnish::config_entry { 'VARNISH_LISTEN_PORT':
          value => 6080,
        }
        EOS

        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes => true)
      end

      describe port(6080) do
        it { is_expected.to be_listening }
      end

      describe port(6082) do
        it { is_expected.to be_listening }
        it do
          pending 'serverspec documentation is abviously not up-to-date'
          is_expected.to be_listening.on('127.0.0.1').with('tcp')
        end
      end
    end
  end

end
