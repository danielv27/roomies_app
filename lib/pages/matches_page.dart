import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/database.dart';
import 'package:roomies_app/backend/matches_provider.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import '../models/user_model.dart';
import '../widgets/matches_page/matches_body.dart';
import '../widgets/matches_page/matches_header.dart';


class MatchesPage extends StatefulWidget {
  const MatchesPage({Key? key}) : super(key: key);

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {

  @override
  void initState() {
    super.initState();
    Provider.of<MatchesProvider>(context, listen: false).loadMatches();
  }

  @override
  Widget build(BuildContext context) {
    final matchesProvider = context.watch<MatchesProvider>();
    if(matchesProvider.userModels == null){
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
          gradient: redGradient()
          ),

          child: Column(
            children: [
              MatchesHeaderWidget(provider: matchesProvider),
              MatchesBodyWidget(provider: matchesProvider)
            ] 
          ),          
        ),
      
    );
  }
}


