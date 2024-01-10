import 'package:ecommerce/models/user.dart';
import 'package:ecommerce/providers/profile.dart';
import 'package:ecommerce/widgets/invoice/image_builder.dart';
import 'package:ecommerce/widgets/invoice/invoice_table.dart';
import 'package:ecommerce/widgets/invoice/save_btn.dart';
import 'package:ecommerce/widgets/invoice/spacer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({Key? key}) : super(key: key);

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
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
              const Text(
                "EgyZona",
                style: TextStyle(fontSize: 25.00, fontWeight: FontWeight.bold),
              ),
              const HeightSpacer(myHeight: 10.00),
              const Divider(),
              const Align(
                alignment: Alignment.topRight,
                child: ImageBuilder(
                  imagePath: "assets/splash.png",
                  imgWidth: 250,
                  imgheight: 250,
                ),
              ),
              const InvoiceBuilder(),
              const SizedBox(height: 100.00), // Add dynamic spacing here
              _buildUserInfoTile("Name:", user.username),
              _buildUserInfoTile("Phone Number:", user.phoneNumber ?? "N/A"),
              _buildUserInfoTile("Shipping Address:", user.location),
              const Text(
                "Thanks for choosing our service!",
                style: TextStyle(color: Colors.grey, fontSize: 15.00),
              ),
              const HeightSpacer(myHeight: 5.00),
              const Text(
                "Contact the branch for any clarifications.",
                style: TextStyle(color: Colors.grey, fontSize: 15.00),
              ),
              const HeightSpacer(myHeight: 15.00),
              const SaveBtnBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoTile(String label, String value) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(fontSize: 18.00, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 18.00, fontWeight: FontWeight.normal),
      ),
    );
  }
}