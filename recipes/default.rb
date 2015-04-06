node['mount']['devices'].each do |device|
  execute "mkfs -t #{device[:format]} #{device[:name]}" do
    not_if "e2label #{device[:name]}"
  end

  directory device[:path]

  mount device[:path] do
    device device[:name]
    fstype device[:format]
    action [:mount, :enable]
  end
end
