import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/providers/favorite.dart';
import 'package:ecommerce/providers/home.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/widgets/all_products/categories_list.dart';
import 'package:ecommerce/widgets/all_products/products_grid.dart';
import 'package:ecommerce/widgets/all_products/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AllProductsPage extends StatefulWidget {
  String? searchWord;
  AllProductsPage({Key? key, this.searchWord}) : super(key: key);

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  final TextEditingController _searchController = TextEditingController();

  Future getAllProducts({required String categoryId}) async {
    if (context.read<HomeProvider>().homeAllProducts.isEmpty) {
      await context
          .read<HomeProvider>()
          .setHomeAllProducts(categoryId: categoryId);
    }
  }

  Future getAllfavorites() async {
    if (context.read<FavoriteProvider>().favoriteItems.isEmpty) {
      List<ProductModel> allProducts =
          context.read<HomeProvider>().homeAllProducts;
      String userId = context.read<UserProvider>().user.uid;
      await context.read<FavoriteProvider>().getFavorites(userId, allProducts);
    }
  }

  Future getCart() async {
    String userId = context.read<UserProvider>().user.uid;

    if (context.read<HomeProvider>().cartProducts == null) {
      await context.read<HomeProvider>().setCartProducts(userId);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllProducts(categoryId: "0"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(''),
            );
          } else {
            getAllfavorites();
            getCart();
            return buildBody();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }
      },
    );
  }

  void onSearch(String query) {
    context.read<HomeProvider>().searchProducts(query);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This callback will be called after the widgets are rendered on the screen
      if (widget.searchWord != null && widget.searchWord!.isNotEmpty) {
        onSearch(widget.searchWord!);
        _searchController.text = widget.searchWord!;
      }
    });
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AllProductsTopBarWidget(
          onQueryChanged: onSearch,
          searchController: _searchController,
        ),
        const CategoriesList(),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 80),
            child: const ProductsGrid(),
          ),
        ),
      ],
    );
  }
}
