class User {
  final String firstname;
  final String lastname;
  final String email;

  final String phone;
  final String residence;

  User({this.firstname, this.lastname, this.email, this.phone, this.residence});

  Map toJson() => {
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'phone': phone,
        'residence': residence,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstname: json['firstname'],
        lastname: json['lastname'],
        email: json['email'],
        phone: json['phone'],
        residence: json['residence'],
      );
}
