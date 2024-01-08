import 'package:ecommerce/models/orders.dart';
import 'package:ecommerce/models/user.dart';
import 'package:ecommerce/providers/profile.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/widgets/invoice/spacer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoiceBuilder extends StatelessWidget {
  const InvoiceBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? user = context.read<ProfileProvider>().userProfile;
    if (user == null) {
      context.read<ProfileProvider>().setUserProfile(context.read<UserProvider>().user.uid);
      user = context.read<ProfileProvider>().userProfile;
    }

    OrdersModel order = context.read<ProfileProvider>().mostRecentOrder!;

    return Column(
      children: [
        SizedBox(height: 10.00), // Added SizedBox
        Container(
          color: const Color.fromARGB(179, 0, 255, 127), // Using RgbColor instead of PdfColor
          width: double.infinity,
          height: 36.00,
          child: Center(
            child: Text(
              "Order ID: ${order.orderId}\n",
              style: TextStyle(
                color: Color.fromARGB(122, 0, 0, 0), // Using RgbColor instead of PdfColor
                fontSize: 20.00,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        header(),
        const HeightSpacer(myHeight: 10.00),
        tableHeader(),
        buildTableData(context, order),
        buildTotal(order),
      ],
    );
  }

  Widget header() => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          Icon(
            Icons.file_open,
            color: Colors.indigo,
            size: 35.00,
          ),
          WidthSpacer(myWidth: 5.5),
          Text(
            "Invoice",
            style: TextStyle(fontSize: 23.00, fontWeight: FontWeight.bold),
          ),
        ],
      );

  Widget tableHeader() => Container(
        color: const Color.fromARGB(255, 189, 255, 191),
        width: double.infinity,
        height: 36.00,
        child: const Center(
          child: Text(
            "Approvals",
            style: TextStyle(
              color: Color.fromARGB(255, 0, 107, 4),
              fontSize: 20.00,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  Widget buildTableData(BuildContext context, OrdersModel order) {
    return Container(
      color: const Color.fromARGB(255, 236, 236, 236),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: order.products.entries.length,
        itemBuilder: (context, index) {
          var item = order.products.entries.elementAt(index);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${item.key.name}",
                  style: TextStyle(
                    fontSize: 18.00,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$ ${item.key.price * item.value}",
                  style: TextStyle(
                    fontSize: 18.00,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Add this function to your class
double calculateTotal(OrdersModel order) {
  double total = 0.0;
  for (var entry in order.products.entries) {
    total += entry.key.price * entry.value;
  }
  return total;
}

Widget buildTotal(OrdersModel order) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 25.0),
  child: Container(
    color: const Color.fromARGB(255, 255, 251, 251),
    width: double.infinity,
    height: 36.00,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "\$ ${calculateTotal(order)}", // Removed const from here
          style: TextStyle(
            fontSize: 22.00,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 107, 4),
          ),
        ),
      ],
    ),
  ),
);

}
