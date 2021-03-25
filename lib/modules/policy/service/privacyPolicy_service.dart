import 'package:restaurant/GlobleService/APIRequest.dart';
import 'package:restaurant/constants/api_path.dart';

class PrivacyPolicyService {
  Future getPrivacy() async {
    String url = "$baseUrl/public/pages/customer/pandp";
    var res = await APIRequest().get(myUrl: url);
    print(res.data);
    return res.data['data']['body'];
  }
}
