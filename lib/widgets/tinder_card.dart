import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/widgets/card_provider.dart';

class TinderCard extends StatefulWidget {
  const TinderCard({Key? key, required this.urlImage}) : super(key: key);

  final String urlImage;

  @override
  State<TinderCard> createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {
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
        ),
      );
}
