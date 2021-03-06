#
# Cookbook Name:: kurento
# Recipe:: test-files
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

# Install subversion
package 'subversion'

# Checkout repository http://files.kurento.org/svn/kurento
directory "#{node['kurento']['home']}/test-files" do
    action :delete
    recursive true
    ignore_failure true
end
subversion "test-files" do
    repository "http://files.kurento.org/svn/kurento"
    revision "HEAD"
    destination "#{node['kurento']['home']}/test-files"
    user node['kurento']['user']
    group node['kurento']['user']
    svn_arguments "--config-dir #{node['kurento']['home']}/.subversion"
    svn_info_args "--config-dir #{node['kurento']['home']}/.subversion"
    action :sync
    timeout 3600
    retries 3
    retry_delay 120
end