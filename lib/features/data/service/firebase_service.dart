import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseFirebaseService<T> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<T>> getAll();
  Future<T> get(String id);
  Future<void> create(T entity);
}
