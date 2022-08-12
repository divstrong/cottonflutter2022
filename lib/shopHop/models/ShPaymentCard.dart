class ShPaymentCard {
  String cardNo ;
  String month ;
  String year ;
  String cvv ;
  String holderName;
  ShPaymentCard({this.cardNo = "",this.cvv = "",this.holderName = "",this.month = "",this.year = ""});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardNo'] = this.cardNo;
    data['month'] = this.month;
    data['year'] = this.year;
    data['cvv'] = this.cvv;
    data['holderName'] = this.holderName;
    return data;
  }
}
