import '../../../GlobleService/APIRequest.dart';
import '../../../constants/api_path.dart';

class TermConditionService {
  Future getTerm() async {
    String url = "$baseUrl/public/pages/manager/tandc";
    var res = await APIRequest().get(myUrl: url);
    print(res.data);
    return res.data['data']['body'];
  }
}
