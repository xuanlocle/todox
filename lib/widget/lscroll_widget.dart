import 'package:flutter/material.dart';

class LScrollView extends StatelessWidget {
  List<Widget> slivers;
  ScrollController? controller;

  LScrollView(this.slivers, {this.controller});

  @override
  Widget build(BuildContext context) => CustomScrollView(
      controller: controller ?? ScrollController(),
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: this.slivers);
}
