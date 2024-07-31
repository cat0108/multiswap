# node1
nv set acl example1 rule 10 action police
nv set acl example1 rule 10 action police mode packet
nv set acl example1 rule 10 action police burst 1548000
nv set acl example1 rule 10 action police rate 1548000

nv set acl example2 type ipv4
nv set acl example2 rule 10 action police
nv set acl example2 rule 10 action police mode packet
nv set acl example2 rule 10 action police burst 774000
nv set acl example2 rule 10 action police rate 774000

nv set interface swp1 acl example1 inbound
nv set interface swp1 acl example2 outbound


nv set acl example3 type ipv4
nv set acl example3 rule 10 action police
nv set acl example3 rule 10 action police mode packet
nv set acl example3 rule 10 action police burst 774000
nv set acl example3 rule 10 action police rate 774000

nv set acl example4 type ipv4
nv set acl example4 rule 10 action police
nv set acl example4 rule 10 action police mode packet
nv set acl example4 rule 10 action police burst 387000
nv set acl example4 rule 10 action police rate 387000

nv set interface swp3 acl example3 inbound
nv set interface swp3 acl example4 outbound


nv config apply

