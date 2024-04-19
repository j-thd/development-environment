# What is this repository?
Hi! If you are reading this, you are looking at my first and succesful attempt to setup my toolchain, in my preferred text editors: VS Code.

I am currently working on my own project for my portfolio, in which I want to demonstrate which (embedded) programming skills I have. To keep track of what I learned in this small task, here is what I learned.

# Demonstrated skills

I learned all steps of the toolchain to turn a basic Blinky project into a bingit ary that can be directly flashed onto the MCU.
This involved using and understanding the following subjects:


* Startup code and scatter file
    * Self-written vector table in assembly (accidentally included the vendor one. TODO: replace with my own)
    * Self-written scatter file to place startup code correctly in memory.
* ARM Toolchain and flashing
    * Self-written commands to understand building process
    * armclang
    * armlink
    * fromelf
    * lmflash (Texas Instrument flashing tool compatible with ICDI)
* Makefile
    * Automating the entire toolchain
    * Device-specific code is interchangeable by changing the target name
    * Automatically includes all source files
* Visual Studio Code
    * Setting up IntelliSense for project (with correct #defines)
    * Setting up Cortex Debug plugin correctly
    * Setting up OpenOCD correctly
    * Providing SVD to look into peripherals.
* CMSIS
    * Small change made in it to correct an error in provided file