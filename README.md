# Roommate

## Sprint 1

### 1. Data model


### 2. Login page
- get the current user netid after login successfully
- download current user info from vapor server after login successfully

### 3. Main page
- download the list during initialization
- listing potential roommates
- Hard filter for specific attributes - gender, etc.

### 4. Profile page (self & other)
- profile modification
- Setting Soft filter (ranking) for most attributes, profiles shown based highest match -> lowest
- click on a user on the main page to see their profile
- coordinate multi views with tabview
- UI design

### 5. Vapor server

#### API

- GET /roommate/user/{netid} // get current user data
- GET /roommate/list //get the list data for main page
- POST /roommate/modify-profile

