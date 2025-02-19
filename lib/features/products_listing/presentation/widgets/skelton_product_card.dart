import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonProductCard extends StatelessWidget {
  const SkeletonProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Skeletonizer(
                child: SizedBox(width: double.infinity, height: 100),
              ),
            ),
            SizedBox(height: 8),
            Skeletonizer(
                child: Text("Product Name", style: TextStyle(fontSize: 16))),
            SizedBox(height: 4),
            Skeletonizer(child: Text("Price", style: TextStyle(fontSize: 14))),
          ],
        ),
      ),
    );
  }
}
