# arch_manual_fan_curve
Allows for the manual fan control of the 7xxx series of cards
I was very confused and annoyed by my 7900xtx hitting 105 in memory temps. So I withheld from playing GPU heavy games. Today, I am tired. 
I eventually ran into this discussion which gave me the knowledge I needed to create the following script. Please be careful using it and
I would read what was mentioned in the thread so you understand what is happening. Here is what the script does:

1. **Checking for Root Access:**
   The script starts by making sure it is being run with root access, which is like having administrator privileges. This is important because the actions the script is going to perform require these higher-level permissions. If the script is not run as root, it will stop and tell you that it needs root privileges.

2. **Updating GRUB Configuration:**
   - **What is GRUB?** GRUB is the program that runs when your computer starts up and lets you choose which operating system to boot, in case you have more than one.
   - **What does the script do here?** The script looks for a specific line in the GRUB configuration file that starts with `GRUB_CMDLINE_LINUX_DEFAULT`. This line tells GRUB some extra instructions about how to start Linux. The script adds a new instruction `amdgpu.ppfeaturemask=0xffffffff` to this line. This specific instruction is used to unlock extra features for AMD graphics cards.
   - **Asking for Confirmation:** Before making this change permanent, the script asks if you're sure you want to proceed with updating GRUB. This is a safety measure because updating GRUB is a significant action and can affect how your computer starts up.

3. **Setting Up the GPU Fan Curve:**
   - **Finding the Fan Control File:** The script looks for a special file in your system that controls how the fan on your AMD graphics card behaves. This file tells the fan how fast to spin at different temperatures.
   - **Setting Fan Speeds:** If the script finds this file, it sets up a series of instructions that define how the fan's speed should change as the temperature of the graphics card increases. For example, it sets the fan to spin at 30% speed when the temperature is 40 degrees Celsius, 50% at 50 degrees, and so on up to 100% at 80 degrees.
   - **Asking for Confirmation Again:** Just like with the GRUB update, the script asks for your confirmation before applying these fan settings. This is another safety measure.

4. **Committing the Changes to the GPU:**
   If you confirm, the script will apply these new fan settings to the graphics card. This means from now on, the fan will follow these rules you've set for how fast to spin at different temperatures.
