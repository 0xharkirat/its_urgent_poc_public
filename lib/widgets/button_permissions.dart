import 'package:flutter/material.dart';

class ButtonPermissions extends StatelessWidget {
  const ButtonPermissions({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final IconData iconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(iconData),
        onTap: onPressed,
      ),
    );
  }
}
