class ExpensesModel {
  int id;
  String created_at;
  int created_by;
  String modified_at;
  int modified_by;
  BigInt amount;
  String date;
  String concept;
  String note;
  int type_id;
  int category_id;
  int payment_method_id;
  int user_id;

  ExpensesModel(
    this.id,
    this.created_at,
    this.created_by,
    this.modified_at,
    this.modified_by,
    this.amount,
    this.date,
    this.concept,
    this.note,
    this.type_id,
    this.category_id,
    this.payment_method_id,
    this.user_id
  );

  ExpensesModel.fromJson(Map<String, dynamic> json): 
    id = json['id'],
    created_at = json['created_at'],
    created_by = json['created_by'],
    modified_at = json['modified_at'],
    modified_by = json['modified_by'],
    amount = json['amount'],
    date = json['date'],
    concept = json['concept'],
    note = json['note'],
    type_id = json['type_id'],
    category_id = json['category_id'],
    payment_method_id = json['payment_method_id'],
    user_id = json['user_id'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_at': created_at,
    'created_by': created_by,
    'modified_at': modified_at,
    'modified_by': modified_by,
    'amount': amount,
    'date': date,
    'concept': concept,
    'note': note,
    'type_id': type_id,
    'category_id': category_id,
    'payment_method_id': payment_method_id,
    'user_id': user_id
  };
}