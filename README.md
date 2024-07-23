# SIKU
## Restaurant List Management and Shraing Feature for Google Maps Saved Places Application Development

### SIKU CURRENT STATUS


#### Overall
<img width="628" alt="Screenshot 2024-02-13 at 11 16 17 AM" src="https://github.com/dlworudgg/siku/assets/37742961/dbcb50ee-a64b-4f89-b98d-b832235141ce">

#### Video






#### Structure
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



#### Login and Searching
![sign-in and map](https://github.com/dlworudgg/siku/assets/37742961/e86612be-15e8-4e4c-8d15-1f5dd8911452)


#### Searching Result and Save
![Search and Result](https://github.com/dlworudgg/siku/assets/37742961/f8c10332-f549-4c03-8090-79705825a63e)


#### Saved List
![saved_list](https://github.com/dlworudgg/siku/assets/37742961/f1108837-b20c-45d4-ad91-f8e9d784385d)


#### Saved List Detail
![Siku Saved List detail](https://github.com/dlworudgg/siku/assets/37742961/a17c095e-c63a-4454-a7f9-93f1ec425b3e)


###  Project Objective

SIKU is designed to enhance the user's culinary journey through a focus on restaurant list management and sharing. The application provides users with tools for effective management and sharing of their favorite restaurant lists and reviews within their exclusive groups, all within an intuitive map interface. With enhanced marker customizability, SIKU emphasizes personalized experiences, making sharing and discovering restaurants within an intimate circle more accessible and enjoyable.



### Features To-do.
[X] **Google Map Integration and Place Search**: Implement Google Map service to facilitate place searches seamlessly.


[X] **Place Information Enrichment via Chat-GPT**: Employ Chat-GPT to summarize reviews, providing detailed and user-friendly data to enhance decision-making.

[X] **Marker Customizability**: Develop a feature allowing users to customize the markers within the map for a personalized user experience.

[X] **Top Restaurant List** : Create list of top Restaurant to explore.

[  ] **Sharing**: Enable sharing of restaurant lists and open reviews to only close friends to enhance the credibility of the reviews

[  ] **Integration with Google Map App**: Allow users to save places directly to SIKU via sharing from the Google Map app, ensuring smooth inter-application operation.

...
...



