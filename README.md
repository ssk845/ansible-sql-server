## 🎯 Ansible SQL Server Automation on Windows
This Ansible project automates end-to-end installation and configuration of Microsoft SQL Server on Windows hosts. It includes pre-checks, silent install, hardening, and popular community tools.

**✅ Features**

🔍 Pre-installation checks and environment setup

⚙️ Unattended SQL Server installation

🔐 Post-install configuration and hardening

🛠 Integration with community tools:

- dbatools – SQL Server PowerShell automation
- Ola Hallengren’s Maintenance Solution
- Brent Ozar’s First Responder Kit

---

**📁 Project Structure**

ansible-sql-server/

├── group_vars/

│   └── windows_sql.yml         # Group-specific variables

├── inventory/

│   └── hosts                   # Windows target inventory

├── roles/

│   ├── preinstall_sql/         # WinRM prep, disk setup, prerequisites

│   ├── install_sql/            # Unattended SQL Server installation

│   └── postinstall_sql/        # Tools, tuning, hardening

├── site.yml                    # Main playbook entry

└── README.md

---

**⚙️ Requirements**


✅ Python 3.x

✅ Ansible 2.14+ or newer

✅ WinRM access to Windows targets

✅ SQL Server ISO/setup media or shared path

✅ Internet access (to download tools/modules)

✅ (Optional) Azure Blob storage for setup media


---


**🔐 Configuration**

Set all variables in:

```bash
group_vars/windows_sql.yml
```

Example variables:

 ```yaml 
folders_to_create:
  - path: 'C:\\ExampleDBData'
  - path: 'C:\\ExampleDBBackup'
  - path: 'C:\\ExampleDBLog'
  - path: 'C:\\ExampleTempDB'
  - path: 'C:\\ExampleJobLogs'
```

"Please copy group_vars_example/windows_sql.yml to group_vars/windows_sql.yml and update variables as needed. Do not commit secrets to the repo."

🔐 How to Set the AZURE_SQL_ISO_URL Environment Variable
To avoid hardcoding sensitive SAS tokens or storage URLs in your playbook, this project supports using an environment variable to provide the path to the SQL Server ISO.

On Linux/macOS or GitHub Actions runners:
```bash
export AZURE_SQL_ISO_URL="https://<your-storage-account>.blob.core.windows.net/<your-container>/SQLServer2022.iso?sv=..."
```

On Windows PowerShell:
```powershell
$Env:AZURE_SQL_ISO_URL = "https://<your-storage-account>.blob.core.windows.net/<your-container>/SQLServer2022.iso?sv=..."
```

In your Ansible playbook or role, you can reference this value like so:

```yaml
url: "{{ lookup('env', 'AZURE_SQL_ISO_URL') }}"
```

🔒 Bonus: Use Ansible Vault for Better Secret Management
If you prefer not to use environment variables, you can securely store the SAS URL using [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html).


1. Create a vaulted file:
```bash
ansible-vault create group_vars/windows_sql/vault.yml
```

2. Add your secret:
```yaml
azure_sql_iso_url: "https://<your-storage-account>.blob.core.windows.net/<your-container>/SQLServer2022.iso?sv=..."
```

3. Reference it in your playbook:
```yaml
url: "{{ azure_sql_iso_url }}"
````

4. Run your playbook using the vault password:
```bash
ansible-playbook site.yml --ask-vault-pass
```

✅ This keeps secrets out of version control and makes your automation secure and portable across environments.

---

🚀 How to Run


This project expects you to provide credentials dynamically during playbook execution.

You can pass them in with:

Without Vault:

```bash
ansible-playbook -i inventory/hosts site.yml
```
With Vault:

```bash
ansible-playbook -i inventory/hosts site.yml --ask-vault-pass
```
---

🔐 About Security and SAS Tokens
This project currently uses a Shared Access Signature (SAS) token to securely access the SQL Server ISO file in Azure Blob Storage.

SAS tokens are:

- Easy to use
- Scoped and time-limited
- Suitable for basic or short-term automation

However, for long-term, production, or enterprise use, consider switching to more secure and scalable access methods, such as:

[Azure Managed Identity](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview)

[Azure Service Principal with RBAC](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview)

These can be integrated later to avoid the need for hardcoded tokens and improve automation security.

---

**📜 Playbook Flow**
1. preinstall_sql
-  Enables WinRM
-  Prepares folders, volumes, dependencies

2. install_sql
-  Installs SQL Server silently using Install-DbaInstance

3. postinstall_sql
-  Configure DB Mail New-DbaDbMailAccount and New-DbaDbMailProfile
-  Configure Ola Hallengren maintenance scripts
-  Configure Brent Ozar’s toolkit

---

**🔧 Customization Options**
 -  Change SQL Server edition, features, or instance name
 -  Add your own PowerShell scripts or agents to postinstall_sql
 -  Adjust config file templates for unattended installation
 -  Use Azure Blob, Azure file share, local, etc to mount the ISO file
 -  Change SQL Directores Locations

---

**🧪 Testing**
Use a local or cloud-hosted Windows VM with:
- WinRM enabled
- SQL Server ISO or media accessible

Run a specific task for testing:

```bash
ansible-playbook -i inventory/hosts site.yml --start-at-task="Run SQL Server installation script"
```

Run a specific tags for testing:

```bash
ansible-playbook -i inventory/hosts site.yml --tags "installsql"
```

---

🚧 Future Improvement

- Support for loading secrets from a `.env` file for local development.
- Automatic integration with Ansible Vault in CI/CD pipelines.
- Option to use Azure Key Vault or Managed Identity instead of SAS tokens.

Want to contribute? Open a PR or discussion!

---

**📄 License**
MIT License

---

**👤 Author**

Created by Saad Kanwar

GitHub: @ssk845
