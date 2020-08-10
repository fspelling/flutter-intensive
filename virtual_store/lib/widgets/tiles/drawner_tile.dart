import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawnerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController pageController;
  final int page;

  DrawnerTile(this.icon, this.text, this.pageController, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => pageController.jumpToPage(page),
        child: Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Icon(icon, size: 32, color: Colors.black),
              SizedBox(width: 32),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: pageController.page.round() == page
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
