import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/providers/favorite.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/services/favorite.dart';
import 'package:ecommerce/widgets/product/add_to_cart_button_widget.dart';
import 'package:ecommerce/widgets/product/product_details_widget.dart';
import 'package:ecommerce/widgets/product/product_quantity_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemDetailsPage extends StatefulWidget {
  final ProductModel product;
  const ItemDetailsPage({super.key, required this.product});

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

int myCounter = 1;

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  bool isFavorite = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FavoriteService favoriteService = FavoriteService();

  @override
  void initState() {
    myCounter = 1;
    super.initState();
  }

  Future checkIsFavorite() async {
    bool result =
        await context.read<FavoriteProvider>().checkIsFavourite(widget.product);

    if (result) {
      isFavorite = true;
    }

    return result;
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      String userId = context.read<UserProvider>().user.uid;
      if (isFavorite) {
        context.read<FavoriteProvider>().addToFavorites(userId, widget.product);
        favoriteService.insertToLocalFavorites(userId, widget.product.id);
      } else {
        context
            .read<FavoriteProvider>()
            .removeFromFavorites(userId, widget.product);
        favoriteService.deleteFromLocalFavorites(userId, widget.product.id);
      }
    });
  }

  void incrementCounter() {
    if (myCounter < widget.product.quantity) {
      setState(() {
        myCounter++;
      });
    }
  }

  void decrementCounter() {
    setState(() {
      if (myCounter > 1) {
        myCounter--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkIsFavorite(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return buildBody(context);
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }
      },
    );
  }

  SafeArea buildBody(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProductDetailsWidget(
                  isFavorite: isFavorite,
                  toggleFavorite: toggleFavorite,
                  product: widget.product,
                ),
                const SizedBox(height: 16.0),
                ProductQuantityWidget(
                  incrementCounter: incrementCounter,
                  decrementCounter: decrementCounter,
                  counter: myCounter,
                ),
                const SizedBox(height: 10.0),
                AddToCartButtonWidget(
                  counter: myCounter,
                  product: widget.product,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
