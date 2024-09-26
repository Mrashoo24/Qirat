import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/blocs/user/user_bloc.dart';

class FirebaseService {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  FirebaseService({required this.firebaseAuth, required this.firestore});

  /// Fetch a single document by ID
  Future<DocumentSnapshot<Map<String, dynamic>>> getSingleDocument({
    required String collectionPath,
    required String documentId,
  }) async {
    try {
      final doc = await firestore.collection(collectionPath).doc(documentId).get();
      return doc;
    } catch (e) {
      throw Exception('Failed to fetch document: $e');
    }
  }

  /// Fetch all documents from a collection with optional filters
  Future<List<Map<String, dynamic>>> getAllDocuments({
    required String collectionPath,
    int? limit,
   List<String>? startAfter,
    Map<String, dynamic>? isEqualTowhereConditions, // Optional where conditions
    Map<String, dynamic>? arrayWhereConditions, // Optional where conditions
    Map<String, dynamic>? orderBy,
    bool descending = false,
  }) async {
    try {
      Query<Map<String, dynamic>> query = firestore.collection(collectionPath);

      // Apply where conditions
      if (isEqualTowhereConditions != null) {
        isEqualTowhereConditions.forEach((field, value) {
          query = query.where(field, isEqualTo: value);
        });
      }

      // Apply where conditions array
      if (arrayWhereConditions != null) {
        arrayWhereConditions.forEach((field, value) {
          query = query.where(field, arrayContains: value);
        });
      }

      // Apply ordering
      if (orderBy != null) {
        orderBy.forEach((field, value) {
          query = query.orderBy(field,  descending: descending);
        });
      }

      // Apply pagination
      if (startAfter != null) {
        query = query.startAfter(startAfter);
      }

      // Apply limit
      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to fetch documents: $e');
    }
  }

  /// Fetch documents using custom filters
  Future<List<Map<String, dynamic>>> getDocumentsWithFilters({
    required String collectionPath,
    Map<String, dynamic>? equalTo, // Example: {'fieldName': 'value'}
    Map<String, dynamic>? notEqualTo,
    Map<String, dynamic>? arrayContains,
    String? orderBy,
    bool descending = false,
    int? limit,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  }) async {
    try {
      Query<Map<String, dynamic>> query = firestore.collection(collectionPath);

      // Apply "equalTo" filters
      if (equalTo != null) {
        equalTo.forEach((field, value) {
          query = query.where(field, isEqualTo: value);
        });
      }

      // Apply "notEqualTo" filters
      if (notEqualTo != null) {
        notEqualTo.forEach((field, value) {
          query = query.where(field, isNotEqualTo: value);
        });
      }

      // Apply "arrayContains" filters
      if (arrayContains != null) {
        arrayContains.forEach((field, value) {
          query = query.where(field, arrayContains: value);
        });
      }

      // Apply ordering
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }

      // Apply pagination
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      // Apply limit
      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to fetch documents with filters: $e');
    }
  }

  /// Add or update a document in a collection
  Future<String?> setDocument({
    required String collectionPath,
     String? documentId,
    required Map<String, dynamic> data,
    bool merge = true, // To merge or replace existing document
  }) async {
    try {
      if(documentId != null){
        await firestore
            .collection(collectionPath)
            .doc(documentId)
            .set(data, SetOptions(merge: merge));
        return null;
      }else{
      var doc =   await firestore
            .collection(collectionPath)
            .add(data);
        return doc.id;
      }
    } catch (e) {
      throw Exception('Failed to set document: $e');
    }
  }

  /// Delete a document from a collection
  Future<void> deleteDocument({
    required String collectionPath,
    required String documentId,
  }) async {
    try {
      await firestore.collection(collectionPath).doc(documentId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  logEvent(BuildContext context,String eventname,Map<String,String>params) async {
   var curretnstate =  context.read<UserBloc>().state;
  if(curretnstate is UserLogged)  {

    params["uid"] = curretnstate.user.token.toString();


    await  FirebaseAnalytics.instance.logEvent(name:eventname,parameters: params);

  }else{
    await  FirebaseAnalytics.instance.logEvent(name:eventname,parameters: params);
  }

  }

}
