// import 'package:flutter/material.dart';
// import 'package:kiind_web/core/constants/app_colors.dart';
// import 'package:kiind_web/core/provider/base_provider.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// import '../../core/util/input_validators.dart';

// class ReplyWidget extends StatelessWidget {
//   final String? Function(String?)? validator;
//   final BaseProvider provider;
//   final bool autoFocus;

//   const ReplyWidget({
//     Key? key,
//     this.validator,
//     required this.provider,
//     this.autoFocus = true,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Offstage(
//       offstage: provider.isGuest,
//       child: SafeArea(
//         child: PhysicalModel(
//           elevation: 1,
//           color: Theme.of(context).backgroundColor,
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border.all(
//                   color: Theme.of(context).brightness == Brightness.light
//                       ? Colors.black87
//                       : Colors.white70,
//                   width: 1),
//               borderRadius: BorderRadius.circular(500),
//             ),
//             margin: const EdgeInsets.symmetric(
//               horizontal: 18,
//               vertical: 18,
//             ),
//             padding: const EdgeInsets.symmetric(
//               horizontal: 18,
//               vertical: 10,
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     autofocus: autoFocus,
//                     keyboardType: TextInputType.text,
//                     controller: provider.commentCtrl,
//                     validator: validator ?? baseValidator,
//                     decoration: const InputDecoration(
//                       isDense: true,
//                       hintText: 'Reply...',
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () => provider.postMessage(context),
//                   child: const Icon(
//                     MdiIcons.send,
//                     color: AppColors.primaryColor,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
