class UsersModel {
  final int id;
  final String created_at;
  final int created_by;
  final String modified_at;
  final int modified_by;
  final String first_name;
  final String last_name;
  final String email;
  final String password;
  final String password_token;
  final String photo;
  final bool active;
  final int role_id;

  UsersModel(
    this.id,
    this.created_at,
    this.created_by,
    this.modified_at,
    this.modified_by,
    this.first_name,
    this.last_name,
    this.email,
    this.password,
    this.password_token,
    this.photo,
    this.active,
    this.role_id
  );

  UsersModel.fromJson(Map<String, dynamic> json): 
    id = json['id'],
    created_at = json['created_at'],
    created_by = json['created_by'],
    modified_at = json['modified_at'],
    modified_by = json['modified_by'],
    first_name = json['first_name'],
    last_name = json['last_name'],
    email = json['email'],
    password = json['password'],
    password_token = json['password_token'],
    photo = json['photo'],
    active = json['active'],
    role_id = json['role_id'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_at': created_at,
    'created_by': created_by,
    'modified_at': modified_at,
    'modified_by': modified_by,
    'first_name': first_name,
    'last_name': last_name,
    'email': email,
    'password': password,
    'password_token': password_token,
    'photo': photo,
    'active': active,
    'role_id': role_id
  };
}