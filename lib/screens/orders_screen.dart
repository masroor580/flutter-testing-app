// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../controller/categories_controller.dart';
//
// class OrdersPage extends StatefulWidget {
//   const OrdersPage({super.key});
//
//   @override
//   State<OrdersPage> createState() => _OrdersPageState();
// }
//
// class _OrdersPageState extends State<OrdersPage> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() =>
//         Provider.of<CategoryController>(context, listen: false).fetchCategories());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('OrdersPage build');
//
//     return Scaffold(
//       body: Consumer<CategoryController>(
//         builder: (context, controller, child) {
//           if (controller.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (controller.errorMessage != null) {
//             return Center(child: Text(controller.errorMessage!));
//           }
//
//           if (controller.categories == null || controller.categories!.isEmpty) {
//             return const Center(child: Text("No categories available"));
//           }
//
//           return ListView.builder(
//             itemCount: controller.categories!.length,
//             itemBuilder: (context, index) {
//               final category = controller.categories![index];
//
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 100,
//                       height: 100,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.black),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: CachedNetworkImage(
//                           imageUrl: category.strCategoryThumb ?? '',
//                           placeholder: (context, url) =>
//                           const Center(child: CircularProgressIndicator()),
//                           errorWidget: (context, url, error) =>
//                           const Icon(Icons.error),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             category.strCategory ?? '',
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             category.strCategoryDescription ?? '',
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/categories_controller.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CategoryController>(context, listen: false).fetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    print('OrdersPage build');

    final controller = Provider.of<CategoryController>(context);

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage != null) {
      return Center(child: Text(controller.errorMessage!));
    }

    if (controller.categories == null || controller.categories!.isEmpty) {
      return const Center(child: Text("No categories available"));
    }

    return ListView.builder(
      itemCount: controller.categories!.length,
      itemBuilder: (context, index) {
        final category = controller.categories![index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: category.strCategoryThumb ?? '',
                    placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 300), // Smooth image loading
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.strCategory ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      category.strCategoryDescription ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
