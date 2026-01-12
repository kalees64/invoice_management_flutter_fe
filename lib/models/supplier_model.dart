class SupplierModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String gstin;
  final String pan;

  SupplierModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.gstin,
    required this.pan,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      gstin: json['gstin'],
      pan: json['pan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'gstin': gstin,
      'pan': pan,
    };
  }

  @override
  String toString() {
    return 'SupplierModel{id: $id, name: $name, email: $email, phone: $phone, address: $address, gstin: $gstin, pan: $pan}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SupplierModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
