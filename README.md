# Uber
IOS application which has the same functionality as uber application

Table of contents:
=================

<!--ts-->
   * [Technologies used and cocoapods.](#technologies-used-and-cocoapods)
   * [Prerequisites](#prerequisites)
   * [Clone](#clone)
   * [User Guide For Customers:](#user-guide-for-customers)
      * [Sign Up And Sign In](#sign-up-and-sign-in)
      * [Order Driver](#order-driver)		       
   * [User Guide For Drivers:](#user-guide-for-drivers)		   
      * [Sign Up And Sign In](#sign-up-and-sign-in-for-driver)		    
      * [Get Order](#get-order)		      
      * [Pick Up Customer And Reach Distination](#pick-up-customer-and-reach-distination)		
   * [License](#license)
<!--te-->

Technologies Used And Cocoapods:
===========

  - Swift 4.0 and Xcode 9.0 are used to implement this project.
  - Fire base is used to host the database and track the requests between drivers and customers.
  - Google maps is used to show paths and locations of users.
  - GeoFire is used to make query to find the nearest driver to the customer.
  - Alamofire and SwiftyJSON are used to take the response of google map as Json respond and deserializing it.
  - SVProgressHUD is used to show load ring.
  
Prerequisites:
=============

  - You Should have MacOS (operation system supported by apple.
  - Xcode IDE.

Clone:
=====
  Clone this repo `https://github.com/shazly333/Uber.git`
  
User Guide For Customers:
=======================
  
  Sign Up And Sign In:		
  -------------------
  
  - Enter your email and password and make sure you make switch button on customer side, then press sign up.
  - To sign in just press button sign in and enter your email and password.
  <p align="center">
  <img src="images/signupcustomer.png" width = "200">
    <img src="images/signincustomer.png" width = "200">
  </p>
  
  Order Driver:
  -------------
  
  - Just press on Order Driver button on the upper right side of screen to get the nearset driver for your location.
  
  <p align="center">
  <img src="images/order.png" width = "200">  </p>
  
User Guide For Drivers:
=======================

  Sign Up And Sign In For Driver:		
  ------------------------------
  
  - Enter your email and password and make sure you make switch button on driver side, then press sign up.
  - To sign in just press button sign in and enter your email and password.
  <p align="center">
  <img src="images/signupdriver.png" width = "200">
    <img src="images/signindriver.png" width = "200">
  </p>
  
  Get Order:
  ---------
  - When driver get an order from customer, red path appears on the map to show him the shortest path from his location to the       customer.
  
   <p align="center">
  <img src="images/path.png" width = "200">  </p>
  
 
  Pick Up Customer And Reach Distination:		
  ---------------------------------------

- When driver react to the customer, he should press Pick up botton to clear map from the marker and red path.
- When driver reach to the destination of the customer, he should press Drop Down botton to get the cost.

<p align="center">
  <img src="images/pickup.png" width = "200">
    <img src="images/cost.png" width = "200">
  </p>

License:
========

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)
Copyright (c) 2018 Mohamed Kamal El-Shazly
