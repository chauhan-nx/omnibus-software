name "datadog-gohai"
# Pin to a gohai version that doesn't include the processes collector as it requires changes to the Agent's calls to gohai
default_version "5.7.x-agent"

env = {
  "GOROOT" => "/usr/local/go",
  "GOPATH" => "/var/cache/omnibus/src/datadog-gohai"
}

if ohai['platform_family'] == 'mac_os_x'
  env.delete "GOROOT"
  gobin = "/usr/local/bin/go"
else
  gobin = "/usr/local/go/bin/go"
end

build do
   ship_license "https://raw.githubusercontent.com/DataDog/gohai/master/LICENSE"
   command "#{gobin} get -d -u github.com/DataDog/gohai", :env => env
   command "git checkout #{version} && git pull", :env => env, :cwd => "/var/cache/omnibus/src/datadog-gohai/src/github.com/DataDog/gohai"
   command "cd $GOPATH/src/github.com/DataDog/gohai && #{gobin} run make.go '#{gobin}' && mv gohai #{install_dir}/bin/gohai", :env => env
end
