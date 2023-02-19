# PfSense-Auto-Reboot (Tested on PfSense 2.6.0)
A simple script to reboot you PfSnse box when it is not connected to the internet.

This guide is extremely beginner friendly. I wish I had it, When I was starting out.

* Copy the script to the local pfsense router.
    
    1. Login via ssh using root user and password.
    
    2. Select shell command ```8```.

    3. Change your directory to /usr/local/bin.
    ```
    cd /usr/local/bin
    ```
    4. Download the script file.
    ```
    curl -LJO https://raw.githubusercontent.com/saswatasarkar13/PfSense-Auto-Reboot/main/PfReboot.sh
    ```
    5. Install nano file editor
    ```
    pkg update
    pkg install nano
    ```
    6. Change your wan adapter name, if required (mine is re0) using nano
    ```
    nano PfReboot.sh
    ``` 
    7. (OPTONAL) Change the script to customize your experience.
        - Change the public ip of cloudflare to your liking (public server). But make sure it is a always on public ip address and does respond to ping (ICMP).
        - Uncomment the print lines. if you want to see feedback on the console. But by-default it is off.

    8. After Pasting the Script. Press ```ESC``` then ```:x``` to exit from the vi editor. 


* To test the script on your local pfsense box.

    1. Install bash, if not installed already. 
    ```     
    pkg install bash
    ```
    2. Change permisson to executable.
    ``` 
    chmod +x PfReboot.sh
    ```
    3. Run it as "bash PfReboot.sh".
    ```
    bash PfReboot.sh
    ```

* To run the the script on your local pfsence box on schedule.

    1. Install cron, if not installed already. 

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
      - Command - ``` bash /usr/local/bin/Pfreboot.sh ``` 

    3. Click on Save. 

Now we are done. You can sleep peacefully and dont have to press the reset button when the internet is goes down. It will automatically reboot itself within sometime of going offline. 
        
Feedback is always welcome.

