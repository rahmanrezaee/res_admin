import '../../../GlobleService/APIRequest.dart';
import '../../../constants/api_path.dart';

class PrivacyPolicyService {
  Future getPrivacy() async {
    String url = "$baseUrl/public/pages/manager/pandp";
    var res = await APIRequest().get(myUrl: url);
    print(res.data);
    return res.data['data']['body'];
  }
}
