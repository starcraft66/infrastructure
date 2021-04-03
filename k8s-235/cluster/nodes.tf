resource "proxmox_vm_qemu" "k8s-node" {
  count       = var.node_count
  name        = "node${count.index + 1}.k8s.235.tdude.co"
  desc        = "Kubernetes Worker Node ${count.index + 1}"
  target_node = count.index % 2 == 0 ? "fleetfoot" : "soarin"

  # clone = "focal-server-cloudimg-amd64"

  disk {
    format  = "qcow2"
    type    = "scsi"
    storage = "spitfire-proxmox-vm"
    size    = "51404M"
  }

  # The harddisk from the cloned vm
  bootdisk = "scsi0"

  agent   = 1
  cores   = 8
  sockets = 1
  vcpus   = 0
  memory  = 29696
  scsihw  = "virtio-scsi-pci"
  network {
    model   = "virtio"
    bridge  = "vmbr0"
    macaddr = "C2:6A:23:DA:D4:0${count.index}"
    tag     = 30
  }

  # os_type    = "cloud-init"
  qemu_os    = "other"
  ipconfig0  = "ip=172.16.30.${count.index + 10}/24,gw=172.16.30.1,ip6=2607:fa48:6ed8:8a54:100::${count.index + 10}/80,gw6=2607:fa48:6ed8:8a54:100::ffff"
  nameserver = "2607:fa48:6ed8:8a5d::1"

  ciuser = "tristan"

  sshkeys = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAiR1wVz1/m2KXNWIUy02/yftUz+P7B/ZsPQ34PoiyJ/+SFiZBOpAX5KJhdyXwDY1l631CyzYX/yI/6I78GB6qoZGjrLG6g0lk5k70VBsdN+YadaHKn4SEs7KKmf2yNPkVWnCrXnVIqZV/ixLtwzQAnIY11pr5vpwEJjydDvb1+imtT6hyTGvVR2f3ZtBl0LryAW3RisLq9G6m+dlJtLGPJcwsSzSh+dqO9DocLPHff8gEgXyP8TqDQM8iS4lkHQYNlFs6KcSHp7/JE1RShjMSoOYy2VfrpCRrzds0GYTzuirTYo5DL1s3vQuWH5gEWk1tWht8ObjYGondZ7anz4bgXQ==
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8wZwiCGx/LX3xJZ0Yr323Apl43SFG2ETZsCavU06WO1OnybJOrZ6KqYQiO9mmsPjjQYHJApaJPBV2xiuOynfTPrEwZyBl0WqyaicqdczxirIez+ktNM8y/CSQ6XpmhfI/+UtdtHvlikWVEKG6oSQOi+QenXmCnIjZSqMRCOj7x3DD+D7fhIN6I+Ssw6XuPdBzAvDlpJ7vDtL2We7gA2PipX1I7erGsL3CnJzk/7ui9ha7r6Fz4WWwgEMuwx+WUxUuy9kK25SMJWwtzaHbeW3CZoLO0s9Fz4w9Z71hON/j/5xh7ynulFEiuco8zfxW6ySRf1HjlzyUN9GO2OMqqiFs8UCtvLDicv8ooCX1UCUiuEr9TwvAPx2du86bXwKpd0pq0ZZD3ymPxajbPGLLT7FYgzxUXbCpY3OeyD85dJB/JZ+5sMdPyimK26w2abLC9VCOV/+BTf15VjL8qTbby+BQNW1vLPcxauhWXVfhVV8FEVri97fj7wa9z7BIBneiIxjzjkpEWRtR8NhCBczioog81EJAFafWhcLEKBwn05YpN92iLWysBBxefIiBoynkfm+1+Ztu3z351BWxFMBod9DmOE6jf2utD12lCm1KeZ+vhnSfsfsBbhJ7/XfKvZ9ZE3igWhFw3A8FzOuuExKEKQLEgn2gUUa9bfRhdCX7PTeFTw== cardno-000609769932
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqvCOuh+/tsBgxY8I9lYauzLAQgtHSSPBLgyFzM5W0jOKsf/ijNfIFbFsNHisNLJJKCM/x03uQ6o21RHxv4OlNw/0ivLES+ZEnWpLzcQ5HZwmv95LsQRSCTNJC7R60JJVdWXUHAMuCOTzt7mVICsBSLosAI+Nw0ynlUy0OMAmnbgmQHEzWQYcWXoajS06HliPq3VoQBbgcZxLSoBtK6y3imVCqkYUB+1UzghJpWN5U0GGgqau2PVLjsi7mrGMfttDbXrQ5/0ndeEQVJs/r9RpZ+C4qZtyRqCCRnjFr5dVNRb/7HIXpVd2AEN4rNMiBLXJ4iWWExk0GVq3pKp/YeJcesMrPLQn3s+xwAPJfRB49kdHafWCGMt8yhTxMTahUwsUQeX04Sa1Yk+fehHfsxvEk5mZ8viQH27pbSNGPxfvbvhXiMftai0mvtQwDYvp7xa78Ztfogea9yZk8QpQ/M/3B9HWF7bxTlR9Hx7g2hyMBngvmEzBjEgolDXuu++B3O/pOHUikdC6dteI3gdHMW9Vgs6QR94VTXVng5ioo0Ff3UlB1f7MwkBkny+AMwSTssTq/cDa53m/aekU9REZREwHla1p1lGA6vL7RQHO9p5j4bRJ3mqJbjC4H5o0O3cdUZZBkvzi/0Pwtl+NP7aa5JG3mCP3B/BCPCqq9STl7dVpqmQ== cardno-000606923500
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCttbTYPb7neNgKHqHPHebZ/1g8bK9GBsdOWMIFs38vwuCGUHj+ZM5zk7yuaPKaDAf7V4LY/wNpcqy4laX1saIPlbjBPH6BDAlEXnY/VuYJEsPJ8nKlKvIt2AJnn2aJMme2YPQ8fb9+owwadROMH+pbOGGhOqolfc9HqyoCUGKJwaVES5cO0GivQmDGdNS/qp3kx1NMRxd0JKnLDVA1/jQwZqgbF2PdOSfw3s4mttX89lQjFIxHcKp2hdn3ZRWBxfSTChjiv3Wv5FZ4heG4gQhDrCfekJX+3PHPgfCWYbN+7OI4wgw2gOTKNQ+EtXRcY91buVp3/32maajurX7/tEXozOD4Xlu5lVF/TTh3tz2nvEEjqBTRyPFyOQYmz1rApYLi76A5EhRpRBu2NbyGgxq62RQ4wZwMsKUugVrdsh/t9A+QWHxL1ukIKFRJ7ICty1Y4b9aqbERXIoDJGRmtat9xx63y9F8BYIChMXNKZCeaVc3ohixtxY4qBIp9rqM0ZV+jTLocbyKvXn5uKj/Q4LuC34TTCiSVaMxSCHg9uDSF9doJbk+tqpGSkhr55+tRY/nJtHD/3dDGrPugBubtuK2nzlZVm+46MqHEL7CBJiubetsijdDhxWFjtismPOJ52uVwkmndoekn8ZVhsOgJrFIiKgw723KkFEYYI5Zv7m0sqw== automation-key
EOF

}