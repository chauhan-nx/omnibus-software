name "datadog-agent-six"
default_version "master"

dependency "python2"
dependency "python3"

license "Apache"
license_file "LICENSE"
skip_transitive_dependency_licensing true

source :git => "git://github.com/DataDog/datadog-agent-six"

relative_path "datadog-agent-six-#{version}"

if ohai["platform"] != "windows"
  build do
    env = {
        "Python2_ROOT_DIR" => "#{install_dir}/embedded",
        "Python3_ROOT_DIR" => "#{install_dir}/embedded",
        "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib",
    }

    command "cmake -DCMAKE_FIND_FRAMEWORK:STRING=NEVER -DCMAKE_INSTALL_PREFIX:PATH=#{install_dir}/embedded .", :env => env
    command "make -j #{workers}"
    command "make install"
  end
else
  build do
    env = {
        "Python2_ROOT_DIR" => "#{windows_safe_path(python_2_embedded)}",
        "Python3_ROOT_DIR" => "#{windows_safe_path(python_3_embedded)}",
    }

    command "cmake -G \"Unix Makefiles\" .", :env => env
    command "make -j #{workers}"
    command "make install"
  end
end
