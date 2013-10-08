#
# Author:: Jake Vanderdray <jvanderdray@customink.com>
# Cookbook Name:: nagios
# Recipe:: pagerduty
#
# Copyright 2011, CustomInk LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package 'libwww-perl' do
  case node['platform_family']
  when 'rhel', 'fedora'
    package_name 'perl-libwww-perl'
  when 'debian'
    package_name 'libwww-perl'
  when 'arch'
    package_name 'libwww-perl'
  end
  action :install
end

package 'libcrypt-ssleay-perl' do
  case node['platform_family']
  when 'rhel', 'fedora'
    package_name 'perl-Crypt-SSLeay'
  when 'debian'
    package_name 'libcrypt-ssleay-perl'
  when 'arch'
    package_name 'libcrypt-ssleay-perl'
  end
  action :install
end

remote_file "#{node['nagios']['plugin_dir']}/notify_pagerduty.pl" do
  owner 'root'
  group 'root'
  mode 00755
  source node['nagios']['pagerduty']['script_url']
  action :create_if_missing
end

nagios_conf 'pagerduty'

cron 'Flush Pagerduty' do
  user node['nagios']['user']
  mailto 'root@localhost'
  command "#{node['nagios']['plugin_dir']}/pagerduty_nagios.pl flush"
end
