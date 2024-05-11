# RoomMate

Welcome to the official repository of RoomMate, an iOS app tailored for Duke student. RoomMate allows Duke students to quickly and accurately find their matching roommates. Please let me know if anything wrong with the server!

## Features

- **Duke Student Only:** This app is exclusively designed for Duke University students. Users must login with their Duke NetID to access the app’s features, ensuring a secure and student-specific environment.
- **Personalized Filter:** App utilizes data from your profile information and recommends users who are similar to you
- **Video Calling:** The app includes a third-party video calling feature that allows students to easily connect with their potential future roommates.
- **Informational Blogs:** Some suggestions are here especially for students who are going to share housing for the first time.

## Getting Started

### Prerequisites

- Xcode 13 or later
- iPhone 15 Pro (If you're testing with simulator, please choose iPhone 15 Pro. However, if you want to test to video calling feature, you may want to test on your personal device, some UI layout may go weird if your device is of different type.)

### Installation & Running:

1. **Clone the repository:**

   ```bash
   git clone git@gitlab.oit.duke.edu:spring2024/roommate.git
   ```

2. **Navigate to the project directory:**

   ```bash
   cd roommate
   ```

3. **Open the project with XCode**

4. **Run the app with simulators or directly run on your personal device**

## User Guide

### Login with your prestigious Duke NetID

The password is the same as you set in the previous ECE564 homework.

<img src="Screenshots/Login.png" width="250">

### Editing your personal profile for a greater chance of matching

Add some photos and interests to let others know you better! Higher percentage of profile completeness would lead to more accurate matching from others and better profile recommendations!

<img src="Screenshots/Edit3.PNG" width="250">
<img src="Screenshots/Edit2.png" width="250">

### Swipe & Match!

Swipe and apply to people you're interested in to make friends.

<img src="Screenshots/Swipe1.png" width="250">

### See who is interested in you

You can see people who're interested in rooming together with you here and decide whether to accept or deny.

<img src="Screenshots/Swipe2.png" width="250">

### Call him/her to make sure they're the right one

You can call your friends here!  


<img src="Screenshots/Call1.png" width="250">
<img src="Screenshots/Call2.png" width="250">

### Get some suggestions before you move in

Read and filter through articles to gain insight about city communities and renting tips and tricks

<img src="Screenshots/Blog1.png" width="250">
<img src="Screenshots/Blog2.png" width="250"> 

"There are known knowns; these are things we know we know. We know there are known unknowns; that is to say, we know there are some things we do not know. But there are also unknown unknowns—the ones we don't know we don't know."

## Attribution

- RangeSlider.swift

  This range slider component is realized by following the guide of this video:

  [SwiftUI: Double Range Slider with Animation - YouTube](https://www.youtube.com/watch?v=ZKm98sKxBRM)
  
  The code for evaluating javascript from URL was possible through the help of swift copilot
