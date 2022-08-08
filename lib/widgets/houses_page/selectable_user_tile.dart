import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:roomies_app/models/user_model.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import 'package:roomies_app/widgets/matches_page/avatar_with_gradient_border.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class SelectableUserTile extends StatefulWidget {
  final UserModel user;
  final Function(bool selected) onTileClick;

  const SelectableUserTile({
    Key? key,
    required this.user,
    required this.onTileClick
    }) : super(key: key);

  @override
  State<SelectableUserTile> createState() => _SelectableUserTileState();
}

class _SelectableUserTileState extends State<SelectableUserTile> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    Offset distance = const Offset(5,5);
    double blur = 5;

    return GestureDetector(
      onTap: () => setState(() {
        _isSelected = !_isSelected;
        widget.onTileClick(_isSelected);
      }),
      child: AnimatedContainer( 
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: _isSelected? const Color.fromRGBO(245, 247, 251, 1): Colors.white,
          boxShadow: [
            BoxShadow(
              offset: -distance,
              color: Colors.white,
              blurRadius: blur,
              inset: _isSelected
            ),
            BoxShadow(
              offset: distance,
              color: const Color(0xFFA7A9AF),
              blurRadius: blur,
              inset: _isSelected
            )
          ],
          borderRadius: const BorderRadius.all(Radius.circular(20))
        ),
        padding: const EdgeInsets.only(left: 8,right: 8,top: 15,bottom: 15),
        margin: const EdgeInsets.only(right: 20,left: 20, top: 10,bottom: 10),
        child: Row(
          children: [
            AvatarWithGradientBorder(radius: 18, borderWidth: 3, image: widget.user.firstImageProvider),
            const SizedBox(width: 10),
            Text(
              "${widget.user.firstName} ${widget.user.lastName}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color.fromRGBO(190, 40, 62, 1), width: 2)
              ),
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  gradient: _isSelected? CustomGradient().redGradient() : null,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(7),
                ),
            )
            
          ]
        ),
      ),
    );
  }
}




 