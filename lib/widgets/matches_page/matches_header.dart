import 'package:flutter/material.dart';
import 'package:roomies_app/backend/database.dart';
import 'package:roomies_app/widgets/matches_page/matches_body.dart';
import '../../models/user_model.dart';

class MatchesHeaderWidget extends StatelessWidget {
  final List<UserModel> users;

  const MatchesHeaderWidget({
      Key? key,
      required this.users
    }) : super(key: key);
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top:32),
      child: Column(
        children: [
          searchBar(users),
          SizedBox(height: MediaQuery.of(context).size.height*0.02),
          circularUserList(context, users),
        ],
      ),
    );
  }
}

Widget searchBar(List<UserModel> users){
  DateTime now = DateTime.now();
  String dayTime = "morning";
  if(now.hour >= 21){
    dayTime = "night";
  }
  else if(now.hour >= 18){
    dayTime = "evening";
  }
  else if(now.hour >= 12){
    dayTime = "afternoon";
  }
  return FutureBuilder(
    future: FireStoreDataBase().getCurrentUser(),
    builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.done){
        UserModel currentUser = snapshot.data as UserModel;
        return AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          actions: [
            GestureDetector(
              onTap: () { 
                print('search pressed');
                  showSearch(
                    context: context,
                    delegate: MatchesSearchDelegate(users)
                );
              },
              child: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white.withOpacity(0.4),
                child: const Icon(Icons.search_rounded,color: Colors.white,),
              ),
            ),
            GestureDetector(
              onTap: () {
                print('profile pressed');
              },
              child: CircleAvatar(
                backgroundColor: Colors.red,
                radius: 32,
                backgroundImage: NetworkImage(currentUser.firstImgUrl),
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 16))
      
          ],
          title: Column(
            children: [
               Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Good $dayTime,",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "${currentUser.firstName} ${currentUser.lastName}",
                  style: const TextStyle(
                    //fontSize: 16,
                    color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        );
      }
      if (snapshot.hasError) {
        return const Text(
          "Something went wrong",
        );
      }
      return const Center(child: CircularProgressIndicator(color: Colors.red));
    }
  );
}

Widget circularUserList(BuildContext context, List<UserModel> users){
  return SizedBox(
    height: MediaQuery.of(context).size.height *0.13,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: users.length,
      itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.only(top: 11,left: 15,right: 4),
          child: GestureDetector(
            onTap: () => print('chat with user $index'),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.red[700],
                  radius: 28,
                  backgroundImage: NetworkImage(users[index].firstImgUrl),
                ),
                Text(users[index].firstName, style: TextStyle(color: Colors.white),)
              ],
            ),
          ),
        );
      }
    ), 
  );
}

class MatchesSearchDelegate extends SearchDelegate {
  late final List<UserModel> users;
  MatchesSearchDelegate(usersList){
    users = usersList;
  }
  
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back,color: Colors.red,)
    );
  }
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if(query.isEmpty){
            close(context, null);
          }
          query = '';
        },
        icon: const Icon(Icons.clear,color: Colors.red,))
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    List<UserModel> results = users.where((user){
      final fullName = user.firstName.toLowerCase() + " " + user.lastName.toLowerCase();
      final input = query.toLowerCase();
      return fullName.contains(input);
    }).toList();
    return GestureDetector( //this is for now might remove
      onTap:() => close(context, null),
      child: userTileList(results));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<UserModel> suggestions = users.where((user){
      final fullName = user.firstName.toLowerCase() + " " + user.lastName.toLowerCase();
      final input = query.toLowerCase();
      return fullName.contains(input);
    }).toList();
    return userTileList(suggestions);
  }
}