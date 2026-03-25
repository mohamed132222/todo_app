import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/my_user.dart';

import '../model/task.dart';

class FirebaseUtils {
  static CollectionReference<Task> getTaskCollection(String userId) {
    return getUserCollection()
        .doc(userId)
        .collection(Task.collectionName)
        .withConverter(
          fromFirestore: (snapshot, options) =>
              Task.fromFireStore(snapshot.data()!),
          toFirestore: (task, options) => task.toFireStore(),
        );
  }

  static Future<void> addTask(Task task, String userId) {
    CollectionReference<Task> collection = getTaskCollection(userId);
    DocumentReference<Task> docRef = collection.doc();
    task.id = docRef.id;
    return docRef.set(task);
  }

  static Future<void> deleteTask(Task task, String userId) {
    CollectionReference<Task> collection = getTaskCollection(userId);
    return collection.doc(task.id).delete();
  }

  static CollectionReference<MyUser> getUserCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
          toFirestore: (value, options) => value.toFireStore(),
          fromFirestore: (snapshot, options) =>
              MyUser.fromFireStore(snapshot.data()!),
        );
  }

  static Future<void> addUser(MyUser user) {
    return getUserCollection().doc(user.id).set(user);
  }

  static Future<MyUser?> readUser(String userId) async {
    var querySnapshot = await getUserCollection().doc(userId).get();
    return querySnapshot.data();
  }

  static Future<void> updateIsDone(Task task, String userId) {
    return getTaskCollection(
      userId,
    ).doc(task.id).update({"isDone": !task.isDone!});
  }

  static Future<void> updateTask(Task task, String userId) {
    return getTaskCollection(userId).doc(task.id).update(task.toFireStore());
  }
}
