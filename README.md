# Carbon_Footprint_Tracker

![Simulator Screenshot - iPhone 14 Pro - 2023-05-15 at 15 03 33](https://github.com/jagz97/Carbon_Footprint_Tracker/assets/68725607/272e5c8e-e277-4278-ace2-a5e65a480027)


Instructions on how to clone an iOS Swift app from GitHub and set it up using Xcode. It also includes steps on installing Xcode tools, running the app in Xcode, and building it for the iPhone simulator.

## Prerequisites
Before you begin, ensure that you have the following prerequisites installed:

- macOS operating system
- Xcode (version 11 or later)
- Git

## Clone the Repository
To clone the repository from GitHub, follow these steps:

1. Open Terminal, which can be found in the Applications > Utilities folder.
2. Navigate to the directory where you want to clone the app.
   ```
   cd /path/to/directory
   ```
3. Clone the repository by running the following command:
   ```
   git clone [https://github.com/your-username/your-app.git](https://github.com/jagz97/Carbon_Footprint_Tracker.git)
   ```
   Replace `your-username` with your GitHub username and `your-app` with the name of your app repository.

## Installing Xcode Tools
Before you can run the app, make sure you have Xcode and its command-line tools installed:

1. Open the App Store on your macOS.
2. Search for "Xcode" and click "Get" to install it.
3. Once Xcode is installed, open it and agree to the license terms.
4. Install the command-line tools by opening Terminal and running the following command:
   ```
   xcode-select --install
   ```

## Opening the Project in Xcode
To open and run the app in Xcode, follow these steps:

1. Open Xcode from the Applications folder or the Launchpad.
2. Click on "Open another project or workspace" or select "Open Developer Tool" and choose "Xcode."
3. Navigate to the directory where you cloned the app repository and select the `.xcodeproj` file.
4. Click "Open" to open the project in Xcode.

## Configuring the Simulator
Before running the app, ensure that you have a simulator set up:

1. In Xcode's toolbar, select a simulator device from the scheme menu.
2. Pick IOS iPhone latest version. 
3. If the desired simulator is not listed, click "Add Additional Simulators..." and choose the simulator you want.
4. Wait for Xcode to download and set up the simulator.

## Running the App
To run the app on the iPhone simulator, follow these steps:

1. Make sure the simulator device is selected in the scheme menu.
2. Click the "Run" button or press `Cmd + R`.
3. Xcode will build the project, and the simulator will launch automatically.
4. The app will be installed and launched on the simulator.

## Building for a Physical Device
To build and run the app on a physical iPhone or iPad, follow these steps:

1. Connect your iOS device to your Mac using a USB cable.
2. In Xcode's toolbar, select your connected device from the scheme menu.
3. Click the "Run" button or press `Cmd + R`.
4. Xcode will build the project and deploy the app to your connected device.

