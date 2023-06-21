import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DefaultShimmer extends StatelessWidget {
  const DefaultShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Container(
          width: 50,
          height: 50,
          color: Colors.black,
        ),
        //period: Duration(milliseconds: 100),
        //loop: 10,
        //direction: ShimmerDirection.,
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.white);
  }
}
