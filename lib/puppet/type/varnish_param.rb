Puppet::Type.newtype(:varnish_param) do
  @doc = "Manages varnish parameters"

  ensurable

  newparam(:name, :namevar => true) do
    desc "The default namevar"
  end

  newproperty(:value) do
  end

  newparam(:varnish_binary) do
    desc "Path to the varnish binary."

    defaultto { '/usr/sbin/varnishd' }
  end

  newparam(:target) do
    desc "The file in which to store the variable."
  end

  autorequire(:file) do
    self[:target]
  end
end

