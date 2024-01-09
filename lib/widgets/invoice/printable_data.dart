import 'package:ecommerce/models/orders.dart';
import 'package:ecommerce/services/cart.dart';
import 'package:ecommerce/models/cart.dart';
import 'package:ecommerce/pages/payment.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

double calculateTotal(OrdersModel order) {
  double total = 0.0;
  for (var entry in order.products.entries) {
    total += entry.key.price * entry.value;
  }
  return total;
}

pw.Widget buildPrintableData(
  int i,

  final OrdersModel order,
  double totalOrderPrice,
  String name,
  String phoneNumber,
  String shippingAddress,
) =>
    pw.Padding(
      padding: const pw.EdgeInsets.all(25.00),
      child: pw.Column(children: [
        pw.Text("EgyZona",
            style: pw.TextStyle(fontSize: 25.00, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10.00),
        pw.Divider(),
        pw.Align(
          alignment: pw.Alignment.topRight,
          // child: pw.Image(
          //   image,
          //   width: 250,
          //   height: 250,
          // ),
        ),
        pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.SizedBox(width: 5.5),
                pw.Text(
                  "Invoice",
                  style: pw.TextStyle(
                      fontSize: 23.00, fontWeight: pw.FontWeight.bold),
                )
              ],
            ),
            pw.SizedBox(height: 10.00),
            pw.Container(
              color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 36.00,
              child: pw.Center(
                child: pw.Text(
                  "Order ID: ${order.orderId}\n",
                  style: pw.TextStyle(
                      color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      fontSize: 20.00,
                      fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.SizedBox(height: 10.00),
            pw.Container(
              color: const PdfColor(0.5, 1, 0.5, 0.7),
              width: double.infinity,
              height: 36.00,
              child: pw.Center(
                child: pw.Text(
                  "Approvals",
                  style: pw.TextStyle(
                      color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      fontSize: 20.00,
                      fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),

            for (int index = 0; index < order.products.entries.length; index++)
              pw.Container(
                color: index % 2 != 0
                    ? const PdfColor(0.9, 0.9, 0.9, 0.6)
                    : const PdfColor(1, 1, 1, 0.1),
                width: double.infinity,
                height: 36.00,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "${order.products.entries.elementAt(index).key.name} ",
                        style: pw.TextStyle(
                            fontSize: 18.00,
                            fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        "\$ ${order.products.entries.elementAt(index).key.price * order.products.entries.elementAt(index).value}",
                        style: pw.TextStyle(
                            fontSize: 18.00,
                            fontWeight: pw.FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
              child: pw.Container(
                width: double.infinity,
                height: 36.00,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, // Adjusted alignment
                  children: [
                    pw.Text(
                      "Total Price:", // Added text here
                      style: pw.TextStyle(
                        fontSize: 18.00,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      "\$ ${totalOrderPrice}",
                      style: pw.TextStyle(
                        fontSize: 22.00,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor(0.2, 0.6, 0.2, 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
            pw.SizedBox(height: 15.00),
            _buildRowWithText("Name:", name),
            _buildRowWithText("Phone Number:", phoneNumber),
            pw.SizedBox(height: 15.00),
            
            // Use FittedBox to handle long text without overflowing
            pw.FittedBox(
              child: _buildRowWithText("Shipping Address:", shippingAddress),
            ),
            
            pw.SizedBox(height: 15.00),
            _buildText("Thanks for choosing our service!", color: PdfColor(0.5, 0.5, 0.5, 0.5)),
            pw.SizedBox(height: 5.00),
            _buildText("Contact the branch for any clarifications.", color: PdfColor(0.5, 0.5, 0.5, 0.5)),
            pw.SizedBox(height: 15.00),
          ],
        ),
      ]),
    );

pw.Row _buildRowWithText(String label, String value) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(
        label,
        style: pw.TextStyle(fontSize: 18.00, fontWeight: pw.FontWeight.bold),
      ),
      pw.Text(
        value,
        style: pw.TextStyle(fontSize: 18.00, fontWeight: pw.FontWeight.normal),
      ),
    ],
  );
}

pw.Text _buildText(String text, {PdfColor? color}) {
  return pw.Text(
    text,
    style: pw.TextStyle(color: color, fontSize: 15.00),
  );
}

