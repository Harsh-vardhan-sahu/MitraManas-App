import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BlogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addBlog(String title, String content) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final docRef = _firestore.collection('users').doc(user.uid);
    final userDoc = await docRef.get();

    if (!userDoc.exists || userDoc['name'] == null) {
      throw Exception('User name not found in Firestore');
    }

    final userName = userDoc['name'];

    await _firestore.collection('blog').add({
      'title': title,
      'content': content,
      'authorId': user.uid,
      'authorName': userName,
      'likes': [],
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> updateBlog(String blogId, String title, String content) async {
    await _firestore.collection('blog').doc(blogId).update({
      'title': title,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteBlog(String blogId) async {
    await _firestore.collection('blog').doc(blogId).delete();
  }

  Stream<QuerySnapshot> getUserBlogs(String authorId) {
    return _firestore
        .collection('blog')
        .where('authorId', isEqualTo: authorId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
