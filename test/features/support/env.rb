require 'fileutils'

Before do
  ['cert.pem', 'key.pem', 'dhparam.pem'].each do |f|
    FileUtils.touch("/etc/ssl/private/#{f}")
  end

  # Mock Nginx
  File.write("/usr/sbin/nginx", "#!/bin/bash")
end