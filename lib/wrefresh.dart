import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartrefresh/smartrefresh.dart';

class Wrefresher extends StatelessWidget {
  final RefreshController controller;
  final Widget child;
  final VoidCallback onRefresh;
  const Wrefresher({super.key, required this.controller, required this.child, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(

      child: PullToRefresh(
          child: child,
          onFail:const  SizedBox(),
          onComplete: const SizedBox(),
          onLoading: Text("Loading..."),
          onRefresh: onRefresh,
          refreshController: controller,
      ),
    );
  }
}
