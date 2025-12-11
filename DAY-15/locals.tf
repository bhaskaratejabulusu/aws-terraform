locals {
  primary_user_data = <<-EOF
    #!/bin/bash
    # Update packages
    apt-get update -y

    # Install Apache
    apt-get install apache2 -y

    # Start Apache
    systemctl start apache2
    systemctl enable apache2

    # Create a sample HTML page
    echo "<h1>Hello from Terraform EC2 Local Variable!</h1>" > /var/www/html/index.html
  EOF

   secondary_user_data = <<-EOF
    #!/bin/bash
    # Update packages
    apt-get update -y

    # Install Apache
    apt-get install apache2 -y

    # Start Apache
    systemctl start apache2
    systemctl enable apache2

    # Create a sample HTML page
    echo "<h1>Hello from Terraform EC2 Local Variable!</h1>" > /var/www/html/index.html
  EOF

}