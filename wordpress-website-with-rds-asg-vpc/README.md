**Terraform configuration code for to create Multi-Service Web Application Deployment with Terraform**

Objective:
Design and deploy a highly available web application on AWS using Terraform. The application
should utilize multiple AWS services and consider cost optimization.
Task Description:
Apply the task to a WordPress+MySql setup, one per EC2 instance
1. WordPress Server (Machine 1):
- Role: Web Server.
- Software Stack:
- OS: Linux (e.g., Ubuntu or CentOS).
- Web Server: Apache or Nginx.
- PHP: Required by WordPress.
- WordPress: The core application.
- Configuration:
- WordPress configuration to connect to the remote MySQL database.
- Appropriate security configurations to ensure only necessary ports are
open and the server is hardened.
2. MySQL Server (Machine 2):
- Role: Database Server.
- Software Stack:
- OS: Linux.
- MySQL: For database requirements of WordPress.
- Configuration:
- Security: Only allow database connections from the WordPress server.
- Regular backups and performance tuning as necessary.

Deployment Steps:
1. MySQL Server Setup:
- Install MySQL on Machine 2.
- Create a database for WordPress.
- Create a user with the necessary privileges and grant access from Machine 1's IP.
- Ensure the firewall only allows connections on the MySQL port from Machine 1.

2. WordPress Server Setup:
- Install the web server, PHP, and other required modules on Machine 1.
- Download and install WordPress.
- During the installation, specify the remote MySQL database on Machine 2.
- Complete the WordPress setup, including themes, plugins, etc

