// import 'package:flutter/material.dart';

// class PostCard extends StatefulWidget {
//   PostCard(
//       {required this.post,
//       required this.fristButtonOnPress,
//       required this.fristIcon,
//       required this.secondButtonOnPress,
//       required this.secondIcon}); 
//   Map<String, dynamic> post;
//   VoidCallback fristButtonOnPress;
//   VoidCallback secondButtonOnPress;
//   Icon fristIcon;
//   Icon secondIcon;

//   @override
//   State<PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(child: Text(widget.post['creatoremail']![0])),
//                 SizedBox(width: 10),
//                 Text(widget.post['creatoremail']!,
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//             SizedBox(height: 12),
//             Text(widget.post['title']!,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//             SizedBox(height: 8),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.network(
//                   widget.post['image'] ??
//                       "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg",
//                   height: 160,
//                   width: double.infinity,
//                   fit: BoxFit.cover),
//             ),
//             SizedBox(height: 8),
//             Text(widget.post['body']!),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 IconButton(onPressed:widget.fristButtonOnPress, icon: widget.fristIcon),
//                 Text("${(widget.post['likes'] as List).length}"),
//                 IconButton(
//                     onPressed: widget.secondButtonOnPress, icon: widget.secondIcon),
//                     Text("${(widget.post['comments'] as List).length}"),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final bool isEdit ;
  final Map<String, dynamic> post;
  final VoidCallback fristButtonOnPress;
  final VoidCallback secondButtonOnPress;
  final Icon fristIcon;
  final Icon secondIcon;

  const PostCard({
    super.key,
    required this.post,
    required this.fristButtonOnPress,
    required this.fristIcon,
    required this.secondButtonOnPress,
    required this.secondIcon,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    final String email = post['creatoremail'] as String? ?? 'Unknown';
    final String title = post['title'] as String? ?? '';
    final String body = post['body'] as String? ?? '';
    final String image = post['image'] as String? ??
        "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg";

    final List likes = post['likes'] as List? ?? [];
    final List comments = post['comments'] as List? ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Creator Info
            Row(
              children: [
                CircleAvatar(
                  child: Text(email.isNotEmpty ? email[0] : '?'),
                ),
                const SizedBox(width: 10),
                Text(email, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),

            const SizedBox(height: 12),

            // Post Title
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),

            const SizedBox(height: 8),

            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                image,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Text(
                  "⚠️ Couldn't load image",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Post Body
            Text(body),

            const SizedBox(height: 10),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: fristButtonOnPress, icon: fristIcon),
                Text("${isEdit?"": likes.length}"),
                IconButton(onPressed: secondButtonOnPress, icon: secondIcon),
                Text("${isEdit?"": comments.length}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
