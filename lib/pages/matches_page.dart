import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/providers/chat_provider.dart';
import 'package:roomies_app/backend/providers/current_profile_provider.dart';
import 'package:roomies_app/backend/providers/matches_provider.dart';
import 'package:roomies_app/models/user_model.dart';
import '../widgets/matches_page/matches_body.dart';
import '../widgets/matches_page/matches_header.dart';

class MatchesPage extends StatefulWidget {
  
  const MatchesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? currentUser = context.read<CurrentUserProvider>().currentUser?.userModel;
    final MatchesProvider matchesProvider = context.watch<MatchesProvider>();


    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient:  LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
              Color.fromRGBO(239, 85, 100, 1),
              Color.fromRGBO(195, 46, 66, 1),
              Color.fromRGBO(190, 40, 62, 1),
              Color.fromRGBO(210, 66, 78, 1),
              Color.fromRGBO(244, 130, 114, 1),
              ]
            ),
          ),
          child: Column(
            children: [
              MatchesHeaderWidget(currentUser: currentUser, matchesProvider: matchesProvider),
              MatchesBodyWidget(matchesProvider: matchesProvider)
            ],
          ),          
        ),
    );
  }
}


