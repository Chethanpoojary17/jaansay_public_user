import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _mediaQuery.width * 0.06,
            vertical: _mediaQuery.height * 0.03),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: _mediaQuery.width * 0.15,
              width: _mediaQuery.width * 0.15,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: Image.network(
                  "https://cdn.fastly.picmonkey.com/contentful/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=800&q=70",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Alice Josh",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RatingBar(
                    itemSize: 20,
                    initialRating: 3.5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    ignoreGestures: true,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                      "I am a tech enthusiast, looking for work in and around my locality. I have 12 years of experience in IT industry."),
                  SizedBox(
                    height: _mediaQuery.height * 0.02,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}