import 'package:flutter/material.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({
    Key? key,
    required this.aboutMeController, 
    required this.workController, 
    required this.studyController, 
    required this.roomMateController, 
    required this.birthDateController,
  }) : super(key: key);

  final TextEditingController aboutMeController;
  final TextEditingController workController;
  final TextEditingController studyController;
  final TextEditingController roomMateController;
  final TextEditingController birthDateController;

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  String aboutMeDescription = "Write a complete description about the me with at least 100 words...";
  String workDescription = "Tell what do I do for work, why I like this job so much, how many days/hours per week and more...";
  String studyDescription = "Tell what do I do for study, why I like this study so much and more...";
  String roomMateDescription = "Tell what features you are looking in a room mate...";
  String birthDateDescription = "dd/mm/yyyy";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
        child: Column(
          children: <Widget> [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Pesonal profile", 
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Make your profile complete", 
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 30,),
            textLabel("ABOUT ME"),
            const SizedBox(height: 10,),
            TextFormField(
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 10,
              controller: widget.aboutMeController,
              style: const TextStyle(color: Colors.grey),
              cursorColor: Colors.grey,
              decoration: applyInputDecoration(aboutMeDescription)
            ),
            const SizedBox(height: 30,),
            textLabel("WORK"),
            const SizedBox(height: 10,),
            TextFormField(
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 10,
              controller: widget.workController,
              style: const TextStyle(color: Colors.grey),
              cursorColor: Colors.grey,
              decoration: applyInputDecoration(workDescription)
            ),
            const SizedBox(height: 30,),
            textLabel("STUDY"),
            const SizedBox(height: 10,),
            TextFormField(
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 10,
              controller: widget.studyController,
              style: const TextStyle(color: Colors.grey),
              cursorColor: Colors.grey,
              decoration: applyInputDecoration(studyDescription)
            ),
            const SizedBox(height: 30,),
            textLabel("WHAT DO I LIKE TO SEE IN A ROOM MATE"),
            const SizedBox(height: 10,),
            TextFormField(
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 10,              controller: widget.roomMateController,
              style: const TextStyle(color: Colors.grey),
              cursorColor: Colors.grey,
              decoration: applyInputDecoration(roomMateDescription)
            ),
            const SizedBox(height: 30,),
            textLabel("MY DATE OF BIRTH"),
            const SizedBox(height: 10,),
            TextField(
              controller: widget.birthDateController,
              style: const TextStyle(color: Colors.grey),
              cursorColor: Colors.grey,
              textInputAction: TextInputAction.next,
              decoration: applyInputDecoration(birthDateDescription)
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

  Widget textLabel(String textLabel) {
    return Row(
      children: <Widget>[
        Image.asset('assets/icons/GradientBlueEllipse.png', width: 11, height: 11,),
        const SizedBox(width: 5,),
        Expanded(
          child: Text(
            textLabel,
            style: const TextStyle(
              fontWeight: FontWeight.w700, 
              fontSize: 14,
              color: Color.fromRGBO(101, 101, 107, 1),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration applyInputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromRGBO(245, 247, 251, 1),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      prefixIcon: const Align(
        widthFactor: 2.0,
        heightFactor: 2.0,
        child: Icon(
          Icons.person_rounded,
        ),
      ),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w300),
    );
  }
}