import 'package:flutter/material.dart';

import '../theme.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({Key? key,
  required this.location,
  required this.press,
    required this.mainText,
  }) : super(key: key);

  final String location;
  final String mainText;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          horizontalTitleGap: 0,
          leading: const Icon(Icons.restaurant,
              color: AppColors.iconDark),
            title :Text(
              mainText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
                style : const TextStyle(
                  color:  AppColors.textDark,
                ),

            ),
          subtitle :Text(
            location,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style : const TextStyle(
              fontSize: 14, // Adjust the font size as needed
              color: AppColors.textFaded,
            ),
          ),
        ),
        const Divider(
            height:5,
            thickness: 1,
            color : AppColors.textFaded
        )
      ],
    );
  }
}
