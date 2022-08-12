import 'package:cotton_natural/shopHop/utils/TextUtils.dart';

class User{

  int id;
  String name,email;

  User(this.id,this.name, this.email);

  static User fromJson(Map<String, dynamic> jsonObject) {



    int id = int.parse(jsonObject['id'].toString());

    String name = jsonObject['name'];
    String email = jsonObject['email'];

    return User(id,name, email);
  }

  static List<User> getListFromJson(List<dynamic> jsonArray) {
    List<User> list = [];
    for (int i = 0; i < jsonArray.length; i++) {
      list.add(User.fromJson(jsonArray[i]));
    }
    return list;
  }




}