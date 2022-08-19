final String tableCategory = 'category';

class Category {
  final int? id;                    // Database only field.
  final String name;                // Model & Database field.
  final double threshold;           // Model & Database field.

  Category({
    this.id,
    required this.name,
    required this.threshold,
  });

  /*
  *   Conversions from Category to
  *   Dart Map and in reverse.
  */

  Map<String, Object?> toMap() => {
    '_id': id,
    'name': name,
    'threshold': threshold,
  };

  static Category fromMap(Map<String, Object?> json) => Category(
    id: json['_id'] as int?,
    name: json['name'] as String,
    threshold: json['threshold'] as double,
  );

  /*
  *   The copy function allows us to create
  *   a copy of the Category and then
  *   add/update fields. This is currently
  *   used for adding "id" to a Category
  *   that does not yet have a unique ID on the
  *   database.
  */

  Category copy({
    int? id,
    String? name,
    double? threshold,
  }) => Category(
      id: id ?? this.id,
      name: name ?? this.name,
      threshold: threshold ?? this.threshold,
  );
}