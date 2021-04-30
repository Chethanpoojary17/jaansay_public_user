import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/coupon.dart';
import 'package:jaansay_public_user/service/dio_service.dart';

class CouponService {
  DioService dioService = DioService();
  String userId = GetStorage().read("user_id").toString();

  getCoupons(List<Coupon> coupons) async {
    final response = await dioService.getData("coupon/user/$userId");

    if (response != null) {
      response['data'].map((e) => coupons.add(Coupon.fromJson(e))).toList();
    }
  }

  getPublicCoupons(List<Coupon> coupons) async {
    final response = await dioService.getData("coupon/public/all");
    if (response != null) {
      response['data'].map((e) => coupons.add(Coupon.fromJson(e))).toList();
    }
  }

  getUserPoints() async {
    final response = await dioService.getData("publicusers/points/$userId");
    if (response != null) {
      return response['data'][0]["points"];
    }
    return 0;
  }

  getCouponPartners(List<CouponPartner> couponPartners, int couponId) async {
    final response = await dioService.getData("coupon/public/$couponId");

    if (response != null) {
      response['data']
          .map((e) => couponPartners.add(CouponPartner.fromJson(e)))
          .toList();
    }
  }

  addCouponUsers(int couponId) async {
    await dioService.postData("coupon/users", {
      "users": [userId],
      "cm_id": couponId
    });
  }

  updateUserPoints(int points) async {
    await dioService
        .patchData("publicusers/points", {"user_id": userId, "points": points});
  }

  Future<Coupon> getCouponDetailsByCouponId(String id) async {
    final response = await dioService.getData("coupon/$id/user/$userId");
    if (response != null) {
      return Coupon.fromJson(response['data'][0]);
    }
    return null;
  }
}
