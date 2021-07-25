import 'package:flutter/material.dart';

Widget SliverItem({Widget? child}) => SliverList(
    delegate: SliverChildBuilderDelegate(
        (context, index) => child ?? Container(),
        childCount: 1,
        addAutomaticKeepAlives: true));

Widget SliverItems({List<Widget>? child}) => SliverList(
    delegate: SliverChildListDelegate(
        List<Widget>.generate(child?.length ?? 0, (int index) => child![index]),
        addAutomaticKeepAlives: true));

Widget SliverGridItems({List<Widget>? child, int? axisCount}) => SliverGrid(
    delegate: SliverChildListDelegate(List<Widget>.generate(
        child?.length ?? 0, (int index) => child![index])),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: axisCount ?? 2, childAspectRatio: 2));
