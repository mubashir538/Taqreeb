import 'package:taqreeb/core/services/flutter_storage.dart';

class MyTokens {
  static const String accessToken = "accessToken";
  static const String refreshToken = "refresh";
  static const String userId = "userId";
  static const String isBusinessOwner = "isBusinessOwner";
  static const String dark = "Dark";
  static const String theme = "Theme";
  static const String bscnic = "bscnic";
  static const String fscnic = "fscnic";
  static const String isFreelancer = "isFreelancer";
  static const String bsusername = "bsusername";
  static const String bsname = "bsname";
  static const String fsname = "fsname";
  static const String fsportfolio = "fsportfolio";
  static const String bsfront = "bsfront";
  static const String bsback = "bsback";
  static const String bsdescription = "bsdescription";
  static const String fsdescription = "fsdescription";
  static const String sfname = "sfname";
  static const String slname = "slname";
  static const String spassword = "spassword";
  static const String semail = "semail";
  static const String sage = "sage";
  static const String scity = "scity";
  static const String sgender = "sgender";
  static const String sphone = "sphone";
  static const String user = "user";
  static const String userType = "userType";
  static const String Light = "Light";
  static const String acname = "acname";
  static const String acdesc = "acdesc";
  static const String aclocation = "aclocation";
  static const String accategory = "accategory";
  static const String acminprice = "acminprice";
  static const String acmaxprice = "acmaxprice";
  static const String moredetails = "moredetails";
  static const String addons = "addons";
  static const String packages = "packages";

  static Future<String> getBusinessType() async {
    String type;

    if (await MyStorage.exists(MyTokens.isBusinessOwner)) {
      type = 'businessowner';
    } else if (await MyStorage.exists(MyTokens.isFreelancer)) {
      type = 'freelancer';
    } else {
      type = 'user';
    }

    return type;
  }

  static void deleteSignupTokens(String type) {
    if (type == 'Freelancer') {
      MyStorage.deleteToken(MyTokens.fscnic);
      MyStorage.deleteToken(MyTokens.fsname);
      MyStorage.deleteToken(MyTokens.fsportfolio);
      MyStorage.deleteToken(MyTokens.fsdescription);
    } else if (type == 'Business') {
      MyStorage.deleteToken(bscnic);
      MyStorage.deleteToken(bsname);
      MyStorage.deleteToken(bsusername);
      MyStorage.deleteToken(bsfront);
      MyStorage.deleteToken(bsback);
      MyStorage.deleteToken(bsdescription);
    } else {
      MyStorage.deleteToken('spassword');
      MyStorage.deleteToken('sfname');
      MyStorage.deleteToken('slname');
      MyStorage.deleteToken('semail');
      MyStorage.deleteToken('scity');
      MyStorage.deleteToken('sgender');
    }
  }
}
