#
# Cookbook Name:: kurento
# Recipe:: npm
#
# Copyright 2014, Kurento
#
# Licensed under the Lesser GPL, Version 2.1 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.gnu.org/licenses/lgpl-2.1.html
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Add nodejs repository
apt_repository 'nodejs' do
  uri          'http://ppa.launchpad.net/chris-lea/node.js/ubuntu'
  distribution node['lsb']['codename']
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          'C7917B12'
end

# Install nodejs
package 'nodejs'

# Configure npm cache (npm.kurento.org) as default NPM registry
cookbook_file "#{node['kurento']['home']}/.npmrc" do
  owner   node['kurento']['user']
  group   node['kurento']['group']
  mode    0660
end

# Enable node to register npm releases 
bash "npm adduser" do
  code <<-EOF
    /usr/bin/expect -c 'spawn npm adduser
    expect "Username: "
    send "#{node['kurento']['npm']['username']}\r"
    expect "Password: "
    send "#{node['kurento']['npm']['password']}\r"
    expect "Email: (this IS public) "
    send "#{node['kurento']['npm']['email']}\r"
    expect eof'
    touch /tmp/npm-adduser
    EOF
  cwd node['kurento']['home']
  user node['kurento']['user']
  group node['kurento']['group']
  environment ({'HOME' => node['kurento']['home']})
end