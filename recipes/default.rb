#
# Author:: Sameer Arora (<sameera@bluepi.in>)
# Cookbook Name:: deploy-play
# Recipe:: default
#
# Copyright 2014, sameer11sep
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

include_recipe 'zip'
include_recipe 'java::oracle'

installation_dir="#{node[:play_app][:install_dir]}"

appName="#{node[:play_app][:application_name]}"

dist_url="#{node[:play_app][:dist_url]}"

config_dir="#{node[:play_app][:config_dir]}"

#Download the Distribution Artifact from remote location

remote_file "#{installation_dir}/#{appName}.zip" do
  source "#{dist_url}"
  mode "0644"
  action :create
end

#Unzip the Artifact and copy to the destination , assign permissions to the start script
bash "unzip-#{appName}" do
  cwd "/#{installation_dir}"
  code <<-EOH
    sudo rm -rf #{installation_dir}/#{appName}
    sudo unzip #{installation_dir}/#{appName}.zip
    sudo chmod +x #{installation_dir}/#{appName}/start
    sudo rm #{installation_dir}/#{appName}.zip
  EOH
end

#Create the Application Conf file
#Add/remove variables here and in the application.conf.erb file as per your requirements e.g Database settings 

template "#{config_dir}/application.conf" do
  source "application.conf.erb"
  variables({
                :applicationSecretKey => "#{node[:play_app][:application_secret_key]}",
                :applicationLanguage => "#{node[:play_app][:language]}"
            })
end

#Define a logger file, change parameter values in attributes/default.rb as per your requirements

template "#{config_dir}/logger.xml" do
  source "logger.xml.erb"
  variables({
                :configDir => "#{config_dir}",
                :appName => "#{appName}",
                :maxHistory => "#{node[:play_app][:max_logging_history]}",
                :playloggLevel => "#{node[:play_app][:play_log_level]}",
                :applicationLogLevel => "#{node[:play_app][:app_log_level]}"
            })
end

#Finally Define a Service for your Application to be kept under /etc/init.d 

template "/etc/init.d/#{appName}" do
  source "initd.erb"
  owner "root"
  group "root"
  mode "0744"
  variables({
                :name => "#{appName}",
                :path => "#{installation_dir}/#{appName}",
                :pidFilePath => "#{node[:play_app][:pid_file_path]}",
                :options => "-Dconfig.file=#{config_dir}/application.conf -Dpidfile.path=#{node[:play_app][:pid_file_path]} -Dlogger.file=#{config_dir}/logger.xml #{node[:play_app][:vm_options]}",
                :command => "start"
            })
end

service "#{appName}" do
  supports :stop => true, :start => true, :restart => true
  action [ :enable, :restart ]
end





