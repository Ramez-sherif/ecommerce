import 'package:ecommerce/models/orders.dart';
import 'package:ecommerce/models/user.dart';
import 'package:ecommerce/providers/home.dart';
import 'package:ecommerce/providers/profile.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/widgets/invoice/image_builder.dart';
import 'package:ecommerce/widgets/invoice/invoice_table.dart';
import 'package:ecommerce/widgets/invoice/save_btn.dart';
import 'package:ecommerce/widgets/invoice/spacer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({Key? key}) : super(key: key);

  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    UserModel user = context.read<ProfileProvider>().userProfile!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(25.00),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "EgyZona",
                style: TextStyle(fontSize: 25.00, fontWeight: FontWeight.bold),
              ),
              HeightSpacer(myHeight: 10.00),
              Divider(),
              Align(
                alignment: Alignment.topRight,
                child: ImageBuilder(
                  imagePath: "assets/girl.png",
                  imgWidth: 250,
                  imgheight: 250,
                ),
              ),
              InvoiceBuilder(),
              SizedBox(height: 100.00), // Add dynamic spacing here
              Text(
                "Name:",
                style: TextStyle(fontSize: 18.00, fontWeight: FontWeight.bold),
              ),
              Text(
                user.username,
                style: TextStyle(fontSize: 18.00, fontWeight: FontWeight.normal),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Phone Number:",
                      style:
                          TextStyle(fontSize: 18.00, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      user.phoneNumber ?? "N/A",
                      style:
                          TextStyle(fontSize: 18.00, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Shipping Address:",
                      style:
                          TextStyle(fontSize: 18.00, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      user.location,
                      style:
                          TextStyle(fontSize: 18.00, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
              Text(
                "Thanks for choosing our service!",
                style: TextStyle(color: Colors.grey, fontSize: 15.00),
              ),
              HeightSpacer(myHeight: 5.00),
              Text(
                "Contact the branch for any clarifications.",
                style: TextStyle(color: Colors.grey, fontSize: 15.00),
              ),
              HeightSpacer(myHeight: 15.00),
              SaveBtnBuilder(),
            ],
          ),
        ),
      ),
    );
  }
}
