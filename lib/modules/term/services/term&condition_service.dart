import 'package:restaurant/GlobleService/APIRequest.dart';
import 'package:restaurant/constants/api_path.dart';

class TermConditionService {
  Future getTerm() async {
    String url = "$baseUrl/public/pages/customer/tandc";
    var res = await APIRequest().get(myUrl: url);
    print(res.data);
    return res.data['data']['body'];
  }
}
