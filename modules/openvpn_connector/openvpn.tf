# provider is too buggy TODO fix when provider gets some love

# resource openvpncloud_network "this" {
#   name = var.name

#   default_connector {
#     name          = "${var.name}-connector"
#     vpn_region_id = var.openvpn_region_id
#   }

#   default_route {
#     value = var.private_subnet.address_prefixes[0]
#     type  = "IP_V4"
#   }
# }
