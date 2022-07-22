import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/database.dart';
import 'package:roomies_app/backend/matches_provider.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import '../models/user_model.dart';
import '../widgets/matches_page/matches_body.dart';
import '../widgets/matches_page/matches_header.dart';


class MatchesPage extends StatelessWidget {
  const MatchesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final matchesProvider = context.watch<MatchesProvider>();
    List<UserModel>? userModels = matchesProvider.userModels;
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
          gradient: redGradient()
          ),

          child: Column(
            children: [
              MatchesHeaderWidget(users: userModels),
              MatchesBodyWidget(users: userModels)
            ] 
          ),          
        ),
      
    );
  }
}


