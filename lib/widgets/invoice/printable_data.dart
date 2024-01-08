import 'package:ecommerce/models/orders.dart';
import 'package:ecommerce/services/cart.dart';
import 'package:ecommerce/models/cart.dart';
import 'package:ecommerce/pages/payment.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget buildPrintableData(
  int i, 
  image,
  final OrdersModel order,
double cartTotalPrice,
  String name,
  String phoneNumber,
  String shippingAddress,
  List<String> itemss,
) => pw.Padding(
  padding: const pw.EdgeInsets.all(25.00),
  child: pw.Column(children: [
    pw.Text("EgyZona",
        style: pw.TextStyle(fontSize: 25.00, fontWeight: pw.FontWeight.bold)),
    pw.SizedBox(height: 10.00),
    pw.Divider(),
    pw.Align(
      alignment: pw.Alignment.topRight,
      child: pw.Image(
        image,
        width: 250,
        height: 250,
      ),
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

        for (var item in order.products.entries)
          pw.Container(
            color: i % 2 != 0
                ? const PdfColor(0.9, 0.9, 0.9, 0.6)
                : const PdfColor(1, 1, 1, 0.1),
            width: double.infinity,
            height: 36.00,
            child: pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  i == 2
                      ? pw.Text(
                          "Tax",
                          style: pw.TextStyle(
                              fontSize: 18.00,
                              fontWeight: pw.FontWeight.bold),
                        )
                      : pw.Text(
                          "${item.key.name} ",
                          style: pw.TextStyle(
                              fontSize: 18.00,
                              fontWeight: pw.FontWeight.bold),
                        ),
                
                  // i == 2

                      pw.Text(
                          "\$ ${item.key.price * item.value}",
                          style: pw.TextStyle(
                              fontSize: 18.00,
                              fontWeight: pw.FontWeight.normal),
                        )
                      // : pw.Text(
                      //     "\$ ${(i + 1) * 7}.00",
                      //     style: pw.TextStyle(
                      //         fontSize: 18.00,
                      //         fontWeight: pw.FontWeight.normal),
                      //   ),
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
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(cartTotalPrice.toString(),
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
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              "Name:",
              style: pw.TextStyle(fontSize: 18.00, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              name,
              style: pw.TextStyle(fontSize: 18.00, fontWeight: pw.FontWeight.normal),
            ),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              "Phone Number:",
              style: pw.TextStyle(fontSize: 18.00, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              phoneNumber,
              style: pw.TextStyle(fontSize: 18.00, fontWeight: pw.FontWeight.normal),
            ),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              "Shipping Address:",
              style: pw.TextStyle(fontSize: 18.00, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              shippingAddress,
              style: pw.TextStyle(fontSize: 18.00, fontWeight: pw.FontWeight.normal),
            ),
          ],
        ),
        pw.SizedBox(height: 15.00),
        pw.Text(
          "Thanks for choosing our service!",
          style: const pw.TextStyle(
              color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 15.00),
        ),
        pw.SizedBox(height: 5.00),
        pw.Text(
          "Contact the branch for any clarifications.",
          style: const pw.TextStyle(
              color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 15.00),
        ),
        pw.SizedBox(height: 15.00),
      ],
    )
  ]),
);
