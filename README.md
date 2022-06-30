# PfSense-Auto-Reboot 
A simple script to reboot you pfsense box while there is not internet.

It guide is extremely beginner friendly. I wish i had it when i was starting out.

* Copy the script of the local pfsense router.
    
    1. Copy the script from github. By clicking on the file and select raw. then copy the whole file.
     
    2. Login via ssh using root user and password.
    
    3. Select shell command ```8```.

    4. Change your directory to /usr/local/bin.
    ```
    cd /usr/local/bin
    ```
    5. Create the script file.
    ```
    vi PfReboot.sh
    ```
    6. Press ```i```. To got insert mode for VI editor.

    7. Press ```Ctrl+Shift+V``` To Paste which you copied on the 1st step.

    8. Change your wan adapter name, if required (mine is re0).
    
    9. (OPTONAL) Change the script to customize your experience.
        - Change the public ip for cloudflare to your liking. and make it is a always on public ip and does respond to ping (ICMP).
        - Uncomment it if you like to see a feedback on the console. By Default it is off.

    10. After Pasting the Script. Press ```ESC``` then ```:x``` to exit from the vi editor. 


* To test the script on your local pfsense router.

    1. Install bash if not installed already. 
    ```     
    pkg install bash
    ```
    2. Change permisson to executable.
    ``` 
    chmod +x PfReboot.sh
    ```
    3. Run it as "bash pfreboot.sh".
    ```
    bash pfreboot.sh
    ```

* To run the the script on your local pfsence router on schedule.

    1. Install cron if not installed already. 

    System > Package Manager > Available Packages > Search "cron" > install.

    2. Configure the cron service.

    Services > corn > add 
    
    Then type as follows
    - Minute - *
    - Hour - *
    - Day of the month - *
    - Month of the year - *
    - Day of the week - *
    - User -  root 
    - Command - ``` bash /usr/local/bin/pfreboot.sh ```
    
    
    3. Click on Save. 

Now we are done. Now you can sleep peacefully. You dont have press the reset button when the internet is gone. It it will automatiatically reboot it self after sometime of going offline. 
        
Feedback is always welcome.

