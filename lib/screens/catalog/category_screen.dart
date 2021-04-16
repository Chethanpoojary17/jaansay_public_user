import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/constants/constants.dart';
import 'package:jaansay_public_user/models/catalog.dart';
import 'package:jaansay_public_user/providers/catalog_provider.dart';
import 'package:jaansay_public_user/screens/catalog/cart_screen.dart';
import 'package:jaansay_public_user/screens/catalog/products_screen.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'file:///C:/Users/Deepak/FlutterProjects/jaansay_public_user/lib/widgets/general/custom_network_image.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  categoryCard(int index, CatalogProvider catalogProvider) {
    Category category = catalogProvider.categories[index];

    return InkWell(
      onTap: () {
        catalogProvider.clearData();
        catalogProvider.selectedCategoryIndex = index;
        Get.to(() => ProductsScreen(), transition: Transition.rightToLeft);
      },
      child: Column(
        children: [
          Expanded(
            child: CustomNetWorkImage(
              category.ccPhoto,
              assetLink: Constants.productHolderURL,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Text(
              category.ccName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogProvider = Provider.of<CatalogProvider>(context);

    if (!catalogProvider.initCategory) {
      catalogProvider.initCategory = true;
      catalogProvider.getAllCategories();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Catalog",
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ),
        actions: [
          if (catalogProvider.isOrder)
            InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Get.to(() => CartScreen(), transition: Transition.rightToLeft);
              },
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 22),
                alignment: Alignment.center,
                child: Badge(
                  badgeContent: Text(
                    catalogProvider.cartProducts.length.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  position: BadgePosition.bottomEnd(),
                  showBadge: catalogProvider.cartProducts.length != 0,
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: 28,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: catalogProvider.isCategoryLoad
          ? CustomLoading()
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Categories",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: catalogProvider.categories.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1 / 1.2,
                            crossAxisSpacing: Get.width * 0.03,
                            mainAxisSpacing: Get.height * 0.02),
                        itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 0.5),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: categoryCard(index, catalogProvider),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
