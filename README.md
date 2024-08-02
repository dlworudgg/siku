![Aug-02-2024 15-59-59](https://github.com/user-attachments/assets/e3803700-3b37-4eb7-815a-ff82c3a7ac05)# SIKU
## AI Generated Restaurant Information Mobile App Development 

### SIKU CURRENT STATUS
Firebase
* Authentication, Firestore Database, Storage, Functions

Data
* Python, Airflow, Selenium, OpenAI API, Google Maps API

Mobile App
* Flutter, Dart

Web App
* Next.js, React, Typescript


#### Video (Please wait for a second to load)

![Aug-02-2024 15-59-59](https://github.com/user-attachments/assets/9e54998b-921e-4c62-99d9-e67bcf0fadc7)

![Aug-02-2024 16-05-21](https://github.com/user-attachments/assets/69000640-9826-461a-b4e7-d460acabfe7f)

![Aug-02-2024 16-07-28](https://github.com/user-attachments/assets/ca99ef0b-7f7a-4665-9af1-9889e3950e9b)



#### App Structure

```
lib
  ├─pages
  │  └─auth_page.dart
  │  └─init_loading_page.dart
  │  └─login_or_register_page.dart
  │  └─messaging_page.dart
  │  └─my_list_page.dart
  │  └─register_page.dart
  │  └─share_room_page.dart
  │  └─shared_list_page.dart
  ├─getx
  │  └─init_controller.dart
  │  └─map_controller.dart
  │  └─my_list_controller.dart
  │  └─place_information_controller.dart 
  ├─models
  │  └─autocomplete_prediction.dart
  │  └─login_my_list_creation.dart
  │  └─open_ai_response.dart
  │  └─place_auto_complete_response.dart
  │  └─place_detail_response.dart
  │  └─result_adapter.dart
  ├─screens
  │  └─login_screen.dart
  │  └─map_screen.dart
  │  └─open_ai_response.dart
  │  └─place_information_screen.dart
  │  └─search_screen.dart
  ├─services
  │  └─auth_service.dart
  │  └─location_service.dart
  │  └─newtwork_utility.dart
  ├─widgets
  │  └─avatar.dart
  │  └─glowing_action_button.dart
  │  └─map_screen_widget.dart
  │  └─widgets.dart
  ├─images    
  └─contstants.dart
  └─helpers.dart
  └─theme.dart
  └─main.dart
  ```



###  Project Objective

SIKU is designed to enhance the user's culinary journey through a focus on restaurant list management and sharing. The application provides users with tools for effective management and sharing of their favorite restaurant lists and reviews within their exclusive groups, all within an intuitive map interface. With enhanced marker customizability, SIKU emphasizes personalized experiences, making sharing and discovering restaurants within an intimate circle more accessible and enjoyable.



### Features To-do.
[X] **Google Map Integration and Place Search**: Implement Google Map service to facilitate place searches seamlessly.


[X] **Place Information Enrichment via ChatGPT**: Employ ChatGPT to summarize reviews, providing detailed and user-friendly data to enhance decision-making.

[ ] **Marker Customizability**: Develop a feature allowing users to customize the markers within the map for a personalized user experience.

[X] **Top Restaurant List** : Create list of top Restaurant to explore.

[  ] **Sharing**: Enable sharing of restaurant lists and open reviews to only close friends to enhance the credibility of the reviews

[X] **Integration with Google Map App**: Allow users to save places directly to SIKU via sharing from the Google Map app, ensuring smooth inter-application operation.

...
...



