describe 'mount::default' do
  context 'one formatted and unformatted drive' do
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

    before do
      stub_command('e2label name1').and_return(false)
      stub_command('e2label name2').and_return(true)
    end

    it 'formats unformatted devices' do
      expect(chef_run).to run_execute('mkfs -t format1 name1')
      expect(chef_run).not_to run_execute('mkfs -t format2 name2')
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
end
