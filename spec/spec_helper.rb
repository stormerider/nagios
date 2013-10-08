require 'chefspec'
require 'berkshelf'

Berkshelf.ui.mute do
  Berkshelf::Berksfile.from_file('Berksfile').install(path: 'vendor/cookbooks/')
end

def runner(attributes = {}, environment = 'test')
  # A workaround so that ChefSpec can work with Chef environments (from https://github.com/acrmp/chefspec/issues/54)
  @runner ||= ChefSpec::ChefRunner.new(:platform => 'ubuntu', :version => '10.04') do |node|
    env = Chef::Environment.new
    env.name environment
    node.stub(:chef_environment).and_return env.name
    Chef::Environment.stub(:load).and_return env

    attributes.each_pair do |key, val|
      node.set[key] = val
    end
  end
end
