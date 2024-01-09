class MessageFunctions {
  getMessage(String type, String name) {
    if (type == "Dependent") {
      return "$name is interested in adding you as dependent on our app. By accepting, $name be able to view your daily nutrient intake report.\n\nPlus, if $name found that you are not taking balanced diet, $name could remind you to do it so!\n\nTo accept or reject this request, click the 'Accept' or 'Reject' button below!";
    } else if (type == "Guardian") {
      return "$name is interested in adding you as guardian on our app. By accepting, you'll be able to view his/her daily nutrient intake report.\n\nPlus, if you found that $name are not taking balanced diet, you could remind him/her to do it so!\n\nTo accept or reject this request, click the 'Accept' or 'Reject' button below!";
    } else if (type == "Dependent Success") {
      return "$name has accepted your dependent request! Now you will be able to view $name's daily nutrient intake report and remind $name to take balanced diet!";
    } else if (type == "Guardian Success") {
      return "$name has accepted your guardian request! Now $name will be able to view your daily nutrient intake report and remind you to take balanced diet!";
    } else if (type == "Dependent Fail") {
      return "$name has rejected your dependent request!";
    } else if (type == "Guardian Fail") {
      return "$name has rejected your guardian request!";
    }
  }

  getTitle(String type, String name) {
    if (type == "Dependent") {
      return "Dependent Request By $name";
    } else if (type == "Guardian") {
      return "Guardian Request By $name";
    } else if (type == "Dependent Success") {
      return "$name Accepted Dependent Request";
    } else if (type == "Guardian Success") {
      return "$name Accepted Guardian Request";
    } else if (type == "Dependent Fail") {
      return "$name Rejected Dependent Request";
    } else if (type == "Guardian Fail") {
      return "$name Rejected Dependent Request";
    }
  }
}
