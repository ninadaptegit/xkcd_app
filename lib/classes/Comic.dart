// ignore_for_file: file_names, prefer_typing_uninitialized_variables, non_constant_identifier_names


import 'package:hive/hive.dart';

part 'Comic.g.dart';

@HiveType(typeId: 0)
class Comic{
  @HiveField(0)
  final String title;
  @HiveField(1)
  final image_url;
  Comic(this.title,this.image_url);
}