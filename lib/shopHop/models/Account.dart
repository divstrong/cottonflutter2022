import 'package:cotton_natural/shopHop/utils/TextUtils.dart';

class Account{

  late int? id;
  late String name,email,token;

  Account(this.id,this.name, this.email, this.token);

  Account.empty(){
    id=null;
    name="";
    email="";
    token="";
  }




}