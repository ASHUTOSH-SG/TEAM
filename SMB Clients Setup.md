## Access Shared Folder from Windows Clients

1. **Connect Using File Explorer**  
   Press `Win + R`, then type:

   ```
   \\storage_node_IP\AIQT
   ```

   *(Replace `storage_node_IP` with your actual server IP.)*

   If prompted for credentials:
   - **Username:** guest  
   - **Password:** (Leave blank, as we enabled guest access.)

2. **Map as a Network Drive (Persistent Access)**  
   - Open File Explorer → Right-click **This PC** → **Map Network Drive**.  
   - Choose a drive letter (e.g., `Z:`).  
   - Enter:  
     ```
     \\storage_node_IP\AIQT
     ```  
   - Check **Reconnect at sign-in** → Click **Finish**.

---

## Access Shared Folder from Linux Clients

1. **Install CIFS Utilities**  
   On each Linux client, install CIFS (Samba client package):

   ```bash
   sudo apt install cifs-utils -y  # Ubuntu/Debian
   sudo yum install cifs-utils -y  # RHEL/CentOS
   ```

2. **Mount the SMB Share**  
   ```bash
   sudo mount -t cifs //storage_node_IP/AIQT /mnt -o guest,uid=$(id -u),gid=$(id -g)
   ```

   *(This mounts the shared folder at `/mnt`.)*

3. **Make the Mount Persistent**  
   Edit the `/etc/fstab` file:

   ```bash
   sudo nano /etc/fstab
   ```

   Add this line:

   ```
   //storage_node_IP/AIQT  /mnt  cifs  guest,uid=1000,gid=1000  0  0
   ```

   Save and exit. Now, the shared folder will mount automatically on reboot.

---

## Verify & Test

- **Windows Clients:** Open `\\storage_node_IP\AIQT` in File Explorer.  
- **Linux Clients:** Check `/mnt` for access.

---