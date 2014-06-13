default['play_app']['install_dir'] = "/opt/play-app"
default['play_app']['dist_url'] = "http://downloads.typesafe.com/play/"
default['play_app']['application_name'] = 'play-app'
default['play_app']['config_dir'] = '/etc/play-app'
default['play_app']['vm_options']='-Xms512M -Xmx1024M -Xss1M -XX:MaxPermSize=512M'
default['play_app']['pid_file_path']="/var/run/play-app.pid"
default['play_app']['application_secret_key']="Your Secret Key here"
default['play_app']['play_log_level']="DEBUG"  
default['play_app']['app_log_level']="DEBUG"
default['play_app']['max_logging_history']="10"
default['play_app']['language']="en"  
