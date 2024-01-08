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
  const SaveBtnBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? user = context.read<ProfileProvider>().userProfile;
    print(user!.email);
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
        printDoc(user!.username, user!.phoneNumber, user!.location, order, 40);
      },
      child: const Text(
        "Save as PDF",
        style: TextStyle(color: Colors.white, fontSize: 20.00),
      ),
    );
  }

  Future<void> printDoc(String username, String? phone, String location, OrdersModel order, double cartTotalPrice) async {
    final image = await imageFromAssetBundle("assets/girl.png");
    final doc = pw.Document();

    final printableData = buildPrintableData(
      0,
      image,
      order,
      cartTotalPrice,
      username,
      phone!,
      location,
    );

    doc.addPage(pw.Page(build: (pw.Context context) {
      return printableData;
    }));

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }
}
