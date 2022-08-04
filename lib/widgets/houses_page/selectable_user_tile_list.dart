import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_model.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import 'package:roomies_app/widgets/houses_page/selectable_user_tile.dart';

class SelectableUserTileList extends StatelessWidget {
  final List<UserModel> users;

  const SelectableUserTileList({
    Key? key,
    required this.users
    }) : super(key: key);

  List<UserModel> getSelectedUsers(List<bool> selectedUsersByIndex){
    List<UserModel> selectedUsers = [];
    for(int i = 0; i < selectedUsersByIndex.length; i++){
      if(selectedUsersByIndex[i]){
        selectedUsers.add(users[i]);
      }
    }
    return selectedUsers;
  }

  @override
  Widget build(BuildContext context) {
    List<bool> selectedUsersByIndex = List.generate(users.length, (index) => false);
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), 
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) { 
                return SelectableUserTile(
                  user: users[index],
                  onTileClick: ((selected) => selectedUsersByIndex[index] = selected),
                );
              }
            ),
            Container(
              margin: const EdgeInsets.only(top: 10,bottom: 20),
              width: MediaQuery.of(context).size.width * 0.6,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                gradient: redGradient()
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  shadowColor: MaterialStateProperty.all(Colors.transparent)
                ),
                onPressed: () {
                  List<UserModel> selectedUsers = getSelectedUsers(selectedUsersByIndex);
                  for (var user in selectedUsers) {
                    print(user.firstName);
                  }
                },
                child: const Text('Create Group Chat')),
            )
          ]
        ),
      ),
    );
  }
}