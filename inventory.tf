resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl",
    {
      app_ips = aws_instance.app.*.public_ip,
      db_ip   = aws_instance.db.private_ip,
    }
  )

  filename = "inventory.ini"
}