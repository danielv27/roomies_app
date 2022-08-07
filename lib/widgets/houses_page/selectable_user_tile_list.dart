import 'package:flutter/material.dart';
import 'package:roomies_app/backend/chat_api.dart';
import 'package:roomies_app/backend/users_api.dart';
import 'package:roomies_app/models/user_model.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import 'package:roomies_app/widgets/houses_page/selectable_user_tile.dart';

class SelectableUserTileList extends StatelessWidget {
  final List<UserModel> users;
  final Function(List<String> selectedUserIDs) onPressed;
  

  const SelectableUserTileList({
    Key? key,
    required this.users,
    required this.onPressed
    }) : super(key: key);

  Future<List<String>> getSelectedUsers(List<bool> selectedUsersByIndex) async {
    
    List<String> selectedUsersIDs = [];
    

    final currentUser = await UsersAPI().getCurrentUserModel();
    if(currentUser != null) selectedUsersIDs.add(currentUser.id);

    for(int i = 0; i < selectedUsersByIndex.length; i++){
      if(selectedUsersByIndex[i]){
        selectedUsersIDs.add(users[i].id);
      }
    }
    return selectedUsersIDs;
  }

  @override
  Widget build(BuildContext context) {
    String? currentUserID;
    List<bool> selectedUsersByIndex = List.generate(users.length, (index) => false);
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
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
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                gradient: redGradient()
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  shadowColor: MaterialStateProperty.all(Colors.transparent)
                ),
                onPressed: () async {
                  List<String> selectedUsersIDs = await getSelectedUsers(selectedUsersByIndex);
                  onPressed(selectedUsersIDs);
                },
                child: const Text('Create Group Chat')),
            )
          ]
        ),
      ),
    );
  }
}