// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:pdf/Pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce/models/orders.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/models/user.dart';
import 'package:ecommerce/providers/profile.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/widgets/invoice/printable_data.dart';

class SaveBtnBuilder extends StatelessWidget {
  const SaveBtnBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? user = context.read<ProfileProvider>().userProfile;
    if (user == null) {
      context.read<ProfileProvider>().setUserProfile(context.read<UserProvider>().user.uid);
      user = context.read<ProfileProvider>().userProfile;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.indigo,
        primary: Colors.indigo,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: () async {
        OrdersModel order = context.read<ProfileProvider>().mostRecentOrder!;
        
        printDoc(user!.username, user!.phoneNumber, user!.location, order);
      },
      child: const Text(
        "Save as PDF",
        style: TextStyle(color: Colors.white, fontSize: 20.00),
      ),
    );
  }
Future<void> printDoc(String username, String? phone, String location, OrdersModel order) async {
  double totalOrderPrice = calculateTotal(order); 
  // final image = await imageFromAssetBundle("assets/splash.png");
  final doc = pw.Document();

  if (order.products.entries.length > 2) {
    final int numberOfPages = (order.products.entries.length / 2).ceil();

    for (int page = 0; page < numberOfPages; page++) {
      final int startIndex = page * 2;
      final int endIndex = (page + 1) * 2;

      final subProducts = order.products.entries
          .toList()
          .sublist(startIndex, endIndex.clamp(0, order.products.entries.length))
          .fold<Map<ProductModel, int>>(
            {},
            (map, entry) => map..[entry.key] = entry.value,
          );

      final subOrder = OrdersModel(
        orderId: order.orderId,
        user: order.user,
        products: subProducts,
        date: order.date,
        status: order.status,
      );

      final printableData = buildPrintableData(
        page,
        subOrder,
        totalOrderPrice,
        username,
        phone!,
        location,
      );

      doc.addPage(pw.Page(build: (pw.Context context) {
        return printableData;
      }));
    }
  } else {
    // Single page
    final printableData = buildPrintableData(
      0,
      order,
      totalOrderPrice,
      username,
      phone!,
      location,
    );

    doc.addPage(pw.Page(build: (pw.Context context) {
      return printableData;
    }));
  }

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
}
}