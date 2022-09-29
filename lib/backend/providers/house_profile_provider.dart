import 'package:flutter/material.dart';
import 'package:roomies_app/backend/houses_api.dart';
import 'package:roomies_app/models/house_profile_model.dart';

class HouseProfileProvider extends ChangeNotifier {
  List<HouseProfileModel>? houseProfileModels;

  int pagesSwiped = 0;
  
  void trimList(){
    //remove elements from beggining of array depending on how many page were swiped
  }

  Future<void> incrementIndex() async {
    pagesSwiped++;
    await loadHouses(20);
  }

  Future<void> loadHouses(int limit) async {
    houseProfileModels == null 
    ? houseProfileModels = await HousesAPI().getNewHouseProfileModels(limit)
    : await HousesAPI().getNewHouseProfileModels(limit).then((newHouse) {
        if(newHouse != null){
          for(var house in newHouse){
            if(!houseProfileModels!.contains(house)){
              houseProfileModels?.add(house);
            }
          }
        }
      });
    notifyListeners();
  }

}