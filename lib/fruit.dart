class Fruit {
  late String name;
  late int id;
  late int cost;
  late int availability;
  late String imageUrl;
  late String details;
  late String category;
  late int quantity;

  Fruit(this.name, this.id, this.cost, this.availability, this.imageUrl,
      this.details, this.category, this.quantity);

  factory Fruit.fromJson(dynamic json) {
    return Fruit(
        json['p_name'] as String,
        json['p_id'] as int,
        json['p_cost'] as int,
        json['p_availability'] as int,
        json['p_image'] as String,
        json['p_details'] != null ? json['p_details'] as String : '',
        json['p_category'] != null ? json['p_category'] as String : '',
        0);
  }

  Map toJson() => {
        'p_name': name,
        'p_id': id,
        'p_cost': cost,
        'p_availability': availability,
        'p_quantity': quantity,
        'p_category': category,
        'p_image': imageUrl,
        'p_details': details
      };
}
