class Favourite
{
  int? favourite_id;
  int? user_id ;
  int? item_id ; 
  
  String? name ; 
  double? rating; 
  List<String>? tags ; 
  double? price ; 
  List<String>? sizes ; 
  List<String>? colors; 
  String? description ; 
  String? image ; 

  Favourite({
    this.favourite_id,
    this.user_id,
    this.item_id,
    this.name,
    this.rating,
    this.tags,
    this.price,
    this.sizes,
    this.colors,
    this.description,
    this.image,
  });

  factory Favourite.fromJson(Map<String,dynamic> json) => Favourite
  (
    favourite_id: int.parse(json['favourite_id']),
    user_id: int.parse(json['user_id']),
    item_id: int.parse(json['item_id']),
    name: json['name'],
    rating: double.parse(json['rating']),
     tags: json["tags"].toString().split(","),
     price: double.parse(json["price"]),
     colors: json["colors"].toString().split(", "),
     sizes: json["sizes"].toString().split(", "),
     description: json["description"],
     image: json["image"], 
  );
}