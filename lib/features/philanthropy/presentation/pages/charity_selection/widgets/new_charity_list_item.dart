import 'package:flutter/material.dart';
import 'package:kiind_web/core/constants/texts.dart';

class NewCharityListItem extends StatelessWidget {
  final String label;
  final String image;
  // final Function() menuFunction1;
  final Function() menuFunction2;
  final Function() menuFunction3;
  final Function() menuFunction4;
  final Function() onTap;
  const NewCharityListItem(
      {super.key,
      required this.label,
      required this.image,
      required this.onTap,
      // required this.menuFunction1,
      required this.menuFunction2,
      required this.menuFunction3,
      required this.menuFunction4});

  @override
  Widget build(BuildContext context) {
    // final translation = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Builder(builder: (context) {
            if (image == '') {
              return const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/icons/app_icon.png'),
              );
            }

            return CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(image),
            );
          }),
          const SizedBox(width: 50),
          Expanded(
            child: customTextNormal(label, alignment: TextAlign.start),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: onTap,
            child: PhysicalModel(
              elevation: 0,
              borderRadius: BorderRadius.circular(40),
              color: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.5,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white54
                            : Colors.black54),
                    borderRadius: BorderRadius.circular(40),
                    color: const Color(0XFF048BD7),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                    child: customTextNormal("view", textColor: Colors.white),
                  )),
            ),
          ),
          PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
              ),
              itemBuilder: (context) => [
                    // PopupMenuItem(
                    //   onTap: menuFunction1,
                    //   child: const Text("Subgroups"),
                    //   value: 1,
                    // ),
                    PopupMenuItem(
                      onTap: menuFunction2,
                      value: 2,
                      child: const Text("Share QR code"),
                    ),
                    PopupMenuItem(
                      onTap: menuFunction3,
                      value: 3,
                      child: const Text("Share A Link"),
                    ),
                    PopupMenuItem(
                      onTap: menuFunction4,
                      value: 4,
                      child: const Text("Share ID"),
                    )
                  ])
        ],
      ),
    );
  }
}
