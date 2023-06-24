# ☁️ Simplified VM Deployment to Proxmox with Terraform and Cloud-Init

This project provides an example implementation of how to provision virtual machines on Proxmox using Terraform and configure them with Cloud-Init. You can use this project as a starting point or reference to understand the provisioning process and configuration management using Terraform and Cloud-Init with Proxmox.

By exploring the code and configuration files in this project, you can gain insights into how to define virtual machine resources, set up Proxmox connectivity, configure Cloud-Init parameters such as hostname, SSH keys, and packages, and more. You can adapt and modify the code according to your specific requirements and infrastructure setup.

## 🔧 Prerequisites

Before you begin, ensure that you have the following prerequisites:

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine
- Access to a Proxmox server or cluster
- SSH key pair for authentication (e.g., `id_rsa` and `id_rsa.pub`)
- [Creating the Proxmox user and role for terraform](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs#creating-the-proxmox-user-and-role-for-terraform)
- [Creating the connection via username and API token](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs#creating-the-connection-via-username-and-api-token)

## ✨ Getting Started

Follow these steps to get started with the project:

1. Clone the repository:

   ```bash
   git clone this repository.
   cd terraform-proxmox-cloud-init
   ```

2. Copy the private key `id_rsa` file to "private_key" folder

   ```bash
   cp ~/.ssh/id_rsa private_key/
   ```

3. Locate the `terraform.tfvars.example` file in the project directory.

4. Create a new file named `terraform.tfvars` by making a copy of the example file:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

5. Open the `terraform.tfvars` file in a text editor.

6. Update the variable values in the `terraform.tfvars` file with your desired configurations. Make sure to replace the example values with your actual settings.

7. Save the `terraform.tfvars` file.

8.  Locate the vms map object declaration in the `main.tf` file.

9. Update the vms map object with your desired virtual machine configurations. Modify the Proxmox connection details, virtual machine settings, Cloud-Init configuration, etc., to match your desired setup.

10. Save the `main.tf` file.

11. Initialize the Terraform working directory:

      ```bash
      terraform init
      ```

12. Review the execution plan:

      With (Environment Variables)
      
      ```bash
      terraform plan -out=plan.tfplan
      ```

      OR (Optional: With secrets.tfvars)

      ```bash
      terraform plan -var-file=terraform.tfvars -var-file=secrets.tfvars -out=plan.tfplan
      ```


13. Provision the virtual machines:

      ```bash
      terraform apply plan.tfplan
      ```

You will be prompted to confirm the provisioning. Type yes to proceed.

14. Terraform will create the virtual machines on the Proxmox server and configure them with Cloud-Init. The process may take some time depending on your infrastructure size and configuration.

15. Once the provisioning is complete, you will see the output with the IP addresses and other relevant information for the provisioned virtual machines.

16. You can now connect to the virtual machines using SSH and the provided IP addresses.

## 🧹 Cleaning Up

To clean up and destroy the provisioned resources, run the following command:

   With (Environment Variables)

   ```bash
   terraform plan -destroy -out=destroy.tfdestroy
   ```

   OR (Optional: With secrets.tfvars)

   ```bash
   terraform plan -var-file=terraform.tfvars -var-file=secrets.tfvars -destroy -out=destroy.tfdestroy
   ```

You will be prompted to confirm the destruction. Type yes to proceed.

Note: Be cautious while running this command as it will destroy all the virtual machines and associated resources.

## 🎨 Customisation

Feel free to customize the project according to your needs. You can modify the Proxmox VM settings, Cloud-Init configuration, add more virtual machines, or extend the functionality as required.

## 📜 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
