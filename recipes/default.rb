node['mount']['devices'].each do |device|
  directory device[:path]

  mount device[:path] do
    device device[:name]
    fstype device[:format]
    action [:mount, :enable]
  end
end
