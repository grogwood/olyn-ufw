# Create a place to store cluster rules
cluster_rules = []

# For SINGLE ports
# Loop through each port item in the data bag
data_bag('ports').each do |ports_item_name|

  # Load the data bag item
  ports_item = data_bag_item('ports', ports_item_name)

  # If this port applies to all clusters, add it into cluster rules
  if ports_item[:cluster]

    # Add the port into cluster rules
    cluster_rules << {
      description: ports_item[:description],
      port:        ports_item[:port],
      protocol:    ports_item[:protocol]
    }

  else
    # Add the single port directly into the firewall rules
    # The UFW wrapper recipe does not support symbols!
    node.override['firewall']['rules'] << {
      ports_item[:description] => {
        'source'   => ports_item[:source],
        'port'     => ports_item[:port],
        'protocol' => ports_item[:protocol]
      }
    }
  end

end

# For CLUSTER ports
# Load information about the current server from the servers data bag
local_server = data_bag_item('servers', node[:hostname])

# Loop through each server in the data bag
data_bag('servers').each do |server_item_name|

  # Load the data bag item
  server = data_bag_item('servers', server_item_name)

  # Skip this server if it isn't in the cluster or is the local server
  next if server[:cluster] != local_server[:cluster] || server[:hostname] == node[:hostname]

  # Loop through each port item in the data bag
  cluster_rules.each do |rule|

    # Add the cluster port into the firewall rules
    # The UFW wrapper recipe does not support symbols!
    node.override['firewall']['rules'] << {
      "#{rule[:description]} (#{server[:hostname]})" => {
        'source'   => server[:ip],
        'port'     => rule[:port],
        'protocol' => rule[:protocol]
      }
    }

  end

end

# Run the ufw configuration recipe
include_recipe 'ufw'
