import 'package:flutter/material.dart';
import 'package:roomies_app/widgets/login_widget.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
    enableDrag: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0), 
        topRight: Radius.circular(30.0)
      ),
    ),
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LoginWidget(),
            ],
          ),
        ),
      );
    }, onClosing: () {  },
    );
  }
}
