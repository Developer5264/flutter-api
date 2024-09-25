import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:api_practice/widgets/reels_item.dart';

class ReelScreen extends StatefulWidget {
  const ReelScreen({super.key});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(),
        // child: StreamBuilder(
        //   stream: _firestore
        //       .collection('reels')
        //       .orderBy('time', descending: true)
        //       .snapshots(),
        //   builder: (context, snapshot) {
        //     return PageView.builder(
        //       scrollDirection: Axis.vertical,
        //       controller: PageController(initialPage: 0, viewportFraction: 1),
        //       itemBuilder: (context, index) {
        //         if (!snapshot.hasData) {
        //           return CircularProgressIndicator();
        //         }
        //         return ReelsItem(snapshot.data!.docs[index].data());
        //       },
        //       itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
        //     );
        //   },
        // ),
      ),
    );
  }
}
