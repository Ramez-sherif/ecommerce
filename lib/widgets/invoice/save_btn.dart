import 'package:ecommerce/models/cart.dart';
import 'package:ecommerce/models/orders.dart';
import 'package:ecommerce/models/user.dart';
import 'package:ecommerce/providers/home.dart';
import 'package:ecommerce/providers/profile.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/services/cart.dart';
import 'package:ecommerce/services/orders.dart';
import 'package:ecommerce/widgets/invoice/printable_data.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/Pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class SaveBtnBuilder extends StatelessWidget {
  const SaveBtnBuilder(
      {Key? key,
      //required this.user,
      //required this.recentOrder,
      //required this.totalOrderPrice
      })
      : super(key: key);
  //final String user;
  //final OrdersModel recentOrder;
  //final double totalOrderPrice;
  @override
  Widget build(BuildContext context) {
    
     UserModel? user = context.read<ProfileProvider>().userProfile;
     print(user!.email);
     if( user == null){
      context.read<ProfileProvider>().setUserProfile(context.read<UserProvider>().user.uid);
      user = context.read<ProfileProvider>().userProfile;
     }
     
    // String username = context.watch<ProfileProvider>().userProfile!.username;
    // String? phone = context.watch<ProfileProvider>().userProfile!.phoneNumber;
    // String location = context.watch<ProfileProvider>().userProfile!.location;
    // final cart = context.read<HomeProvider>().cartProducts!;
      

    // String cartTotalPrice = "${CartService.getTotalPrice(order.products)}";
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
        printDoc(user!.username, user!.phoneNumber, user!.location,
          order, 40);},
      child: const Text(
        "Save as PDF",
        style: TextStyle(color: Colors.white, fontSize: 20.00),
      ),
    );
  }

  Future<void> printDoc(String username, String? phone, String location,
      OrdersModel order, double cartTotalPrice) async {
    final image = await imageFromAssetBundle("assets/girl.png");
    final doc = pw.Document();

    final items = [
      "Item nano",
      "Item modi",
      "Item bodi",
      "Item dedo",
      "Item sese",
      "xcj",
      "hgd",
      "jhv",
      "yoyo",
      "jhfc",
      "hgvj",
      "uyuyu",
      "1",
      "2",
      "3"
    ];

    if (items.length > 3) {
      final int numberOfPages = (items.length / 3).ceil();

      for (int page = 0; page < numberOfPages; page++) {
        final int startIndex = page * 3;
        final int endIndex = (page + 1) * 3;
        final List<String> pageItems =
            items.sublist(startIndex, endIndex.clamp(0, items.length));

        final printableData = buildPrintableData(
          0,
          image,
          order,
          cartTotalPrice,
          username,
          phone!,
          location,
          pageItems,
        );

        doc.addPage(pw.Page(build: (pw.Context context) {
          return printableData;
        }));
      }
    } else {
      // final double cartTotalPrice = CartService.getTotalPrice(cart.products);

      final printableData = buildPrintableData(
        0,
        image,
        order,
        cartTotalPrice,
        username,
        phone!,
        location,
        items,
      );

      doc.addPage(pw.Page(build: (pw.Context context) {
        return printableData;
      }));
    }

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}
