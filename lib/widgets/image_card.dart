import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/widgets/card_provider.dart';

class ImageCard extends StatefulWidget {
  const ImageCard({Key? key, required this.urlImage}) : super(key: key);

  final String urlImage;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  @override
  Widget build(BuildContext context) => SizedBox.expand(
        child: buildFrontCard(),
      );

  Widget buildFrontCard() => GestureDetector(
        child: buildCard(),
        behavior: HitTestBehavior.translucent,
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(
            context,
          );
          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(
            context,
          );
          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(
            context,
          );
          provider.endPosition();
        },
      );

  Widget buildCard() => Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.25,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(widget.urlImage),
        fit: BoxFit.cover,
        alignment: const Alignment(-0.3, 0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
  );
}
