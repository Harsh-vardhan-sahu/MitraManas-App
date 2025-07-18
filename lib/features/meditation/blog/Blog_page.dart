import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart';
import '../../../presentation/home_page/home_page.dart';
import 'create_blog.dart';
import 'edit_blog.dart';

class BlogListScreen extends StatelessWidget {
  const BlogListScreen({super.key});

  Future<void> _toggleLike(DocumentSnapshot blog) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final data = blog.data() as Map<String, dynamic>?;
    if (data == null) return;

    final currentLikes = List<String>.from(data['likes'] ?? []);
    final blogRef = FirebaseFirestore.instance.collection('blog').doc(blog.id);
    final uid = user.uid;

    if (currentLikes.contains(uid)) {
      await blogRef.update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await blogRef.update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: FadeInDown(
          duration: const Duration(milliseconds: 600),

          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                ),
              ),
              const Text(
                "Community Blogs",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        actions: [
          ZoomIn(
            duration: const Duration(milliseconds: 600),
            child: IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.deepPurple, size: 30),
              tooltip: 'Create Blog',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateBlogScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('blog')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No blogs yet",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          final blogs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 100, top: 10),
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final blog = blogs[index];
              final data = blog.data() as Map<String, dynamic>;

              final title = data['title'] ?? 'Untitled';
              final content = data['content'] ?? 'No content';
              final authorName = data['authorName'] ?? 'Unknown';
              final isOwner = data['authorId'] == currentUser?.uid;

              final List<String> likes = List<String>.from(data['likes'] ?? []);
              final isLiked = likes.contains(currentUser?.uid);

              return BlogCard(
                blog: blog,
                title: title,
                content: content,
                authorName: authorName,
                isOwner: isOwner,
                likes: likes,
                isLiked: isLiked,
                onToggleLike: () => _toggleLike(blog),
                onShowEditDelete: () => _showEditDeleteModal(context, blog),
                index: index,
              );
            },
          );
        },
      ),
    );
  }

  void _showEditDeleteModal(BuildContext context, DocumentSnapshot blog) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ElasticIn(
          duration: const Duration(milliseconds: 400),
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blueAccent, size: 28),
                  title: const Text(
                    "Edit Blog",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBlogScreen(blog: blog),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.redAccent, size: 28),
                  title: const Text(
                    "Delete Blog",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final confirm = await showDialog<bool>(
                      context: context,
                      barrierColor: Colors.black.withOpacity(0.7),
                      builder: (context) => BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElasticIn(
                                  child: const Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.redAccent,
                                    size: 60,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Delete Blog",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "Are you sure you want to delete this blog? This action cannot be undone.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    BounceInUp(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[200],
                                          foregroundColor: Colors.black87,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    BounceInUp(
                                      delay: const Duration(milliseconds: 100),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                    if (confirm == true) {
                      await FirebaseFirestore.instance.collection('blog').doc(blog.id).delete();
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BlogCard extends StatefulWidget {
  final DocumentSnapshot blog;
  final String title;
  final String content;
  final String authorName;
  final bool isOwner;
  final List<String> likes;
  final bool isLiked;
  final VoidCallback onToggleLike;
  final VoidCallback onShowEditDelete;
  final int index;

  const BlogCard({
    super.key,
    required this.blog,
    required this.title,
    required this.content,
    required this.authorName,
    required this.isOwner,
    required this.likes,
    required this.isLiked,
    required this.onToggleLike,
    required this.onShowEditDelete,
    required this.index,
  });

  @override
  _BlogCardState createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    const maxLines = 3;
    final isContentLong = widget.content.split('\n').length > maxLines || widget.content.length > 150;

    return FadeInUp(
      duration: Duration(milliseconds: 400 + (widget.index * 100)),
      child: GestureDetector(
        onLongPress: widget.isOwner ? widget.onShowEditDelete : null,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.6),
                Colors.white.withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ZoomIn(
                            child: IconButton(
                              icon: Icon(
                                widget.isLiked ? Icons.favorite : Icons.favorite_border,
                                color: widget.isLiked ? Colors.redAccent : Colors.grey[600],
                                size: 28,
                              ),
                              onPressed: widget.onToggleLike,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AnimatedCrossFade(
                        firstChild: Text(
                          widget.content,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87.withOpacity(0.85),
                            height: 1.6,
                          ),
                          maxLines: maxLines,
                          overflow: TextOverflow.ellipsis,
                        ),
                        secondChild: Text(
                          widget.content,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87.withOpacity(0.85),
                            height: 1.6,
                          ),
                        ),
                        crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                      if (isContentLong) ...[
                        const SizedBox(height: 12),
                        BounceInUp(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: Text(
                              _isExpanded ? 'Read Less' : 'Read More',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "By: ${widget.authorName}",
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.black54.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            widget.likes.isEmpty ? "" : "${widget.likes.length} ❤️",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}