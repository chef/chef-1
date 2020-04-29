# Add chef objects to the server for testing

# Create an organization
execute 'create test organization' do
  command '/opt/opscode/bin/chef-server-ctl org-create test test_org'
  not_if '/opt/opscode/bin/chef-server-ctl org-list | grep test'
end

remote_directory '/fixtures/chef/cb' do
  source 'cb'
end

directory '/var/log/chef' do
  recursive true
end

directory '/var/chef' do
  recursive true
end

file '/etc/opscode/required' do
  content "file '/tmp/required'"
  mode '0600'
end

replace_or_add 'rr turn it on' do
  path '/etc/opscode/chef-server.rb'
  pattern "required_recipe['enable']"
  line "required_recipe['enable'] =  true"
end

replace_or_add 'rr set path' do
  path '/etc/opscode/chef-server.rb'
  pattern "required_recipe['path']"
  line "required_recipe['path'] =  '/etc/opscode/required'"
end

execute 'Change the chef options' do
  command 'chef-server-ctl reconfigure'
end
