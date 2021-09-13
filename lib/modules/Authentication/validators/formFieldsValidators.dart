emailValidator(String v) {
  if (v == null) {
    return "Please Enter Email";
  } else if (!v.contains("@")) {
    return "Please Enter a Valid Email Address";
  }

  // RegExp regExp = new RegExp(
  //   r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
  //   caseSensitive: false,
  //   multiLine: false,
  // );
  // print(regExp.allMatches(v));
}

passwordValidator(String v) {
  if (v.isEmpty) {
    return "Please Enter Password";
  }
}
