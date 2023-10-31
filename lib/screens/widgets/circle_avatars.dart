import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CircleAvatars extends StatelessWidget {
  String? backgroundImage;
  final String userName;

  CircleAvatars({super.key, this.backgroundImage, required this.userName});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green,
            radius: 25,
            child: CircleAvatar(
              backgroundColor: Colors.greenAccent[100],
              radius: 23,
              child: backgroundImage!.isEmpty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(backgroundImage!),
                      radius: 100,
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.person_2_outlined,
                        color: Colors.black,
                      ),
                    )
                  : CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(backgroundImage!),
                    ),
            ),
          ),
          Text(
            userName,
            maxLines: 2,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
