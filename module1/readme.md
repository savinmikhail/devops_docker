1. **SSH Configuration:**
    - In the file `~/.ssh/config`, add:
        ```
        Host savinmikhail.tusur
          ForwardAgent yes
        ```
    - To connect to the host `tusur-facium.ru`:
        ```
        ssh -A пользователь@tusur-facium.ru
        ```
    - To connect to the virtual machine:
        ```
        ssh savinmikhail@savinmikhail.tusur
        ```

2. **Determine Linux Distribution:**
    - To check the Linux distribution:
        ```
        cat /etc/os-release
        ```
        Output:
        ```
        NAME="AlmaLinux"
        VERSION_ID="9.2"
        ```

3. **Clone Repository Permissions:**
    - Change ownership and permissions for cloning a repository:
        ```
        sudo chown savinmikhail:savinmikhail projects
        sudo chmod u+w projects
        ```

4. **Git Configuration:**
    - Add in `~/.ssh/config`:
        ```
        Host gitlab-tusur.faciem.ru
          ForwardAgent yes
        ```
    - Clone a repository:
        ```
        git clone git@gitlab-tusur.faciem.ru:student-repos/savinmikhail.git
        ```

5. **Systemd Unit File Creation:**
    - Create a systemd unit file:
        ```
        sudo nano /etc/systemd/system/myscript.service
        ```
    - Insert:
        ```
        [Unit]
        Description=My Script Service

        [Service]
        Type=simple
        ExecStart=/root/unit/script.sh

        [Install]
        WantedBy=multi-user.target
        ```
    - Make the file executable:
        ```
        sudo chmod +x /root/unit/script.sh
        ```
    - Reload systemd configuration:
        ```
        sudo systemctl daemon-reload
        ```
    - Start the service:
        ```
        sudo systemctl start myscript.service
        ```
    - Check the status:
        ```
        sudo systemctl status myscript.service
        ```

6. **SELinux Configuration:**
    - Execute SELinux configuration:
        ```
        chcon -Rv --type=etc_t /root/unit
        ```

7. **Enable Service Auto-Start:**
    ```
    sudo systemctl enable myscript.service
    ```

8. **Create Directory and Script:**
    - Create a subdirectory:
        ```
        mkdir /root/sudo
        ```
    - Create a script file `test.sh` in the directory:
        ```
        touch /root/sudo/test.sh
        ```
    - Using `nano`, insert:
        ```sh
        #!/bin/sh
        whoami
        touch /root/file
        ```
    - Provide execution rights to the owner only:
        ```
        chmod 700 /root/sudo
        chmod 700 /root/sudo/test.sh
        ```

9. **Create New User:**
    - Create a new user:
        ```
        useradd newuser
        ```
    - Grant execution rights for the script:
        ```
        echo 'newuser ALL=(root) NOPASSWD: /root/sudo/test.sh' > /etc/sudoers.d/newuser
        ```

10. **Mount Partition:**
    - Create a directory:
        ```
        mkdir /root/mounted
        ```
    - Mount the partition:
        ```
        mount /dev/course/part1 /root/mounted
        ```
    - Edit `/etc/fstab` for automatic mount:
        ```
        blkid /dev/course/part1
        ```
        Add to `/etc/fstab`:
        ```
        /dev/course/part1 /root/mounted ext4 defaults 0 2
        ```
    - Test mount:
        ```
        umount /root/mounted
        mount -a
        df -h
        ```

