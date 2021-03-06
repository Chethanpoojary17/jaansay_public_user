// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:badges/badges.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:jaansay_public_user/constants/constants.dart';
import 'package:jaansay_public_user/models/catalog.dart';
import 'package:jaansay_public_user/providers/catalog_provider.dart';
import 'package:jaansay_public_user/screens/catalog/cart_screen.dart';
import 'package:jaansay_public_user/screens/catalog/products_screen.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

class InnerCategoryScreen extends StatelessWidget {
  categoryCard(int index, CatalogProvider catalogProvider) {
    Category category = catalogProvider.innerCategories[index];

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          catalogProvider.clearData();

          if (category.cpId == null) {
            catalogProvider.initInnerCategory = false;
            catalogProvider.isInnerCategoryLoad = true;
            catalogProvider.selectedInnerCategoryIndex = index;
            Get.off(() => InnerCategoryScreen(),
                transition: Transition.rightToLeft, preventDuplicates: false);
          } else {
            catalogProvider.selectedInnerCategoryIndex = index;

            Get.off(() => ProductsScreen(), transition: Transition.rightToLeft);
          }
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogProvider = Provider.of<CatalogProvider>(context);

    if (!catalogProvider.initInnerCategory) {
      catalogProvider.initInnerCategory = true;
      catalogProvider.getAllInnerCategories();
    }

    String categoryName = catalogProvider.selectedInnerCategoryIndex == null
        ? catalogProvider
            .categories[catalogProvider.selectedCategoryIndex].ccName
        : catalogProvider
            .innerCategories[catalogProvider.selectedInnerCategoryIndex].ccName;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          categoryName,
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
      body: catalogProvider.isInnerCategoryLoad
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
                      ).tr(),
                      const SizedBox(
                        height: 16,
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: catalogProvider.innerCategories.length,
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
