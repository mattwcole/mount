describe 'mount::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['mount']['devices'] = [
        {
          :name => 'name1',
          :path => 'path1',
          :format => 'format1'
        },
        {
          :name => 'name2',
          :path => 'path2',
          :format => 'format2'
        }
      ]
    end.converge(described_recipe)
  end

  it 'creates directories' do
    chef_run.node['mount']['devices'].each do |device|
      expect(chef_run).to create_directory(device[:path])
    end
  end

  it 'mounts devices' do
    chef_run.node['mount']['devices'].each do |device|
      expect(chef_run).to mount_mount(device[:path])
        .with(device: device[:name])
        .with(fstype: device[:format])

      expect(chef_run).to enable_mount(device[:path])
        .with(device: device[:name])
        .with(fstype: device[:format])
    end   
  end
end
