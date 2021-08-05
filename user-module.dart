import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(
      () => UserController(),
    );
  }
}
//----------------------- controller ----------------

class UserController extends GetxController with StateMixin<dynamic> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late List<DropdownModel> userDropdownItem = [];
  late DropdownModel? dmModel;

  late TextEditingController fullNameController,
      emailController,
      passwordController,
      confirmPasswordController,
      cityController,
      zipCodeController,
      phoneController;

  late List<String> userActiveStatusList = [];
  late String? selectedStatus;

  late String? deletedUser;

  var email = '';
  var name = '';
  var password = '';
  var confirmPassword = '';
  var city = '';
  var zipCode = '';
  var phone = '';

  late String? userID;

  //////////////////////////////////////////////////////////////////////////////

  late List<UserDetailsData>? userDetailList = [];

  late List<String> userFieldShort = [];
  late String? selectedShortOpt, sortName = "";

  late final isLoading = true.obs;

  late final isSortSelected = false.obs;
  late final isDESCSortSelect = false.obs;
  late final isProcessStart = false.obs;

  @override
  void onInit() {
    super.onInit();
    browseUserList();

    userDropdownItem.insert(0, DropdownModel("0", "select"));
    dmModel = userDropdownItem[0];

    userFieldShort = [
      'Select',
      'Full Name',
      'Email',
      'User Type',
      'Phone',
      'City',
      'Zip Code'
    ];
    selectedShortOpt = userFieldShort[1];

    userActiveStatusList = ['Select', 'Yes', 'No'];
    selectedStatus = userActiveStatusList[1];

    fullNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    cityController = TextEditingController();
    zipCodeController = TextEditingController();
    phoneController = TextEditingController();

    browseUserType();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    clearData();
  }

  String? fullNameValid(String? value) {
    if (value!.trim().isEmpty) {
      return '${Strings.txtFullName}\t${Strings.txtRequired}.';
    }
    return null;
  }

  void checkFrom({bool? isUpdateAvail}) {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      Get.rawSnackbar(
          title: Strings.txtWarning,
          message: Strings.txtWarningText,
          icon: Icon(
            Icons.warning,
            color: Colors.amber,
          ));
      return;
    }

    formKey.currentState!.save();

    addUpdateUser(isUpdate: isUpdateAvail);
  }

  String? emailValid(String? emailStr) {
    if (emailStr!.trim().isEmpty) {
      return '${Strings.txtEmail}\t${Strings.txtIsRequired}';
    } else if (!emailStr.isEmail) {
      return "${Strings.txtEmail}\t${Strings.txtNotValid}";
    }
    return null;
  }

  String? phoneNumberValid(String? phoneStr) {
    if (phoneStr!.trim().isEmpty) {
      return '${Strings.txtPhone}\t${Strings.txtIsRequired}.';
    } else if (!phoneStr.isPhoneNumber) {
      return "${Strings.txtPhone}\t${Strings.txtNotValid}";
    }
    return null;
  }

  String? passwordValid(String? value) {
    if (value!.trim().isEmpty) {
      return '${Strings.txtPassword}\t${Strings.txtIsRequired}';
    } else if (value.length < 8) {
      return 'Password must be 8 char long.';
    }
    return null;
  }

  String? repeatPasswordValid(String? value) {
    if (value!.trim().isEmpty) {
      return '${Strings.txtConfirmPass}\t${Strings.txtIsRequired}';
    } else if (confirmPasswordController.text != passwordController.text) {
      return 'Password is not match.';
    }
    return null;
  }

  String? activeStatusValid(String? value) {
    if (value == userActiveStatusList[0]) {
      return '${Strings.txtReqSelect}\t${Strings.txtIsRequired}';
    }
    return null;
  }

  String? zipCodeValid(String? value) {
    if (value!.trim().isEmpty) {
      return '${Strings.txtZipCode}\t${Strings.txtIsRequired}';
    } else if (!value.isNumericOnly) {
      return 'Zip Code must be in Digit.';
    } else if (value.length < 6) {
      return 'Zip Code is must be grater than 5 Digit';
    } else if (value.length > 6) {
      return 'Zip Code is must be in  6 Digit';
    }
    return null;
  }

  String? userTypeValid(value) {
    if (value! == userDropdownItem[0]) {
      return '${Strings.txtUserType}\t${Strings.txtIsRequired}';
    }
    return null;
  }

  browseUserType() {
    String? token = GetStorage().read(Strings.txtSToken);
    ApiServiceProvider.getUserType(body: {"Token": "$token"}).then((value) {
      var response = userTypeModelFromJson(value!);
      if (response.statuscode == Strings.txt400Code) {
        if (response.status == Strings.txtUnauthorized) {
          GetStorage().erase().then((value) {
            Get.toNamed(Routes.LOGIN);
          });
        } else {
          return change(
            null,
            status: RxStatus.error(response.message),
          );
        }
      } else {
        userDropdownItem.addAll(response.data!.map((e) {
          return DropdownModel(e.userTypeId.toString(), e.userType.toString());
        }).toList());
      }
    }, onError: (error) {
      return change(null, status: RxStatus.error(error.toString()));
    });
  }

  //Delete User
  void removeUser({String? userID}) {
    final refStore = GetStorage();
    String? token = refStore.read(Strings.txtSToken);
    String? userIDLog = refStore.read(Strings.txtSUserIDLog);
    print(userID);
    Map<String, dynamic>? body = {
      "Token": "$token",
      "UserID": "$userID",
      "UserIDLog": "$userIDLog"
    };
    print(body);
    ApiServiceProvider.deleteUser(body: body).then((value) {
      final response = getUserListModelFromJson(value);
      if (response.statuscode == Strings.txt400Code) {
        if (response.status == Strings.txtUnauthorized) {
          refStore.erase().then((value) {
            Get.offAllNamed(Routes.LOGIN);
          });
        } else {
          Get.back();
          Get.snackbar(
            "${Strings.txtUser}\t${Strings.txtDelete}",
            response.message!,
            colorText: Colors.white,
            duration: Duration(seconds: 4),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orangeAccent,
            shouldIconPulse: true,
            icon: Icon(Icons.check_outlined, color: Colors.white),
            margin: EdgeInsets.fromLTRB(5, 1, 10, 18),
          );
        }
      } else {
        Get.back();
        Get.snackbar(
          "${Strings.txtUser}\t${Strings.txtDelete}",
          response.message!,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          margin: EdgeInsets.fromLTRB(5, 1, 5, 20),
          icon: Icon(Icons.check_outlined, color: Colors.white),
        );
        browseUserList();
      }
    }, onError: (error) {
      return change(
        null,
        status: RxStatus.error(error.toString()),
      );
    });
  }

  void addUpdateUser({bool? isUpdate}) {
    final refStore = GetStorage();
    String? userIDLog = refStore.read(Strings.txtSUserIDLog);
    String? token = refStore.read(Strings.txtSToken);
    String? userTypeID = refStore.read(Strings.txtSUserTypeID);
    Map<String, dynamic>? body = isUpdate == false
        ? {
            "UserID": "0",
            "Token": "$token",
            "FullName": "$name",
            "Email": "$email",
            "Password": "$password",
            "UserTypeID": "$userTypeID",
            "Phone": "$phone",
            "City": "$city",
            "Zipcode": "$zipCode",
            "Active": "$selectedStatus",
            "Deleted": "No",
            "UserIDLog": "$userIDLog"
          }
        : {
            "UserID": "$userID",
            "Token": "$token",
            "FullName": "$name",
            "Email": "$email",
            // "Password":"$password",
            "UserTypeID": "$userTypeID", //$userType
            "Phone": "$phone",
            "City": "$city",
            "Zipcode": "$zipCode",
            "Active": "$selectedStatus",
            "Deleted": "$deletedUser",
            "UserIDLog": "$userIDLog"
          };
    isLoading.value = false;
    print(body);
    ApiServiceProvider.addUser(body: body).then((value) {
      Get.back();
      final response = getUserListModelFromJson(value);
      try {
        if (response.statuscode == Strings.txt400Code) {
          if (response.status == Strings.txtUnauthorized) {
            refStore.erase().then((value) {
              Get.offAllNamed(Routes.LOGIN);
            });
          } else {
            Get.snackbar(
              "${Strings.txtUser}",
              response.message!,
              colorText: Colors.white,
              duration: Duration(seconds: 4),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent.shade700,
              icon: Icon(Icons.check_outlined, color: Colors.white),
              margin: EdgeInsets.fromLTRB(5, 1, 10, 18),
              // padding: const EdgeInsets.all(4.0)
            );
          }
        } else {
          Get.snackbar(
            "${Strings.txtUser}",
            response.message!,
            colorText: Colors.white,
            duration: Duration(seconds: 4),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            icon: Icon(Icons.check_outlined, color: Colors.white),
            margin: EdgeInsets.fromLTRB(5, 1, 5, 20),
          );
          browseUserList();
        }
      } catch (error) {
        print(error);
      } finally {
        isLoading.value = true;
      }
    }, onError: (error) {
      return change(
        null,
        status: RxStatus.error(error.toString()),
      );
    });
  }

  void browseUserList({
    bool? isFilterCall = false,
    String? fullName = "",
    String? emailFilter = "",
    int? take = 10,
    int? skip = 0,
    String? columnName = "",
    String? sortOrder = "DESC",
    String? userID = "",
  }) {
    final refStore = GetStorage();
    String? token = refStore.read(Strings.txtSToken);
    String? userIDLog = refStore.read(Strings.txtSUserIDLog);
    Map<String, dynamic>? body = {
      "Token"         : "$token",
      "FullName"      : "${fullName ?? ""}",
      "Email"         : "$emailFilter",
      "Take"          : "$take",
      "Skip"          : "$skip",
      "UserIDLog"     : "$userIDLog",
      "ColumnName"    : "$columnName",
      "SortDirection" : "$sortOrder",
      "UserID"        : "$userID"
    };
    isLoading.value = false;
    ApiServiceProvider.getUserList(body: body).then((value) {
      print(value);
      if(isFilterCall == true){
        Get.back();
      }
      if (value != null) {
        final response = getUserListModelFromJson(value);
        if (response.statuscode == Strings.txt400Code) {
          if (response.status == Strings.txtUnauthorized) {
            refStore.erase().then((value) {
              Get.toNamed(Routes.LOGIN);
              // Get.offAllNamed(Routes.LOGIN);
            });
          } else {
            return change(
              null,
              status: RxStatus.error(response.message),
            );
          }
        } else {
          isLoading.value = true;
          isProcessStart.value = false;
          return change(response.data, status: RxStatus.success());
        }
      }
    }, onError: (err) {
      return change(
        null,
        status: RxStatus.error(err.toString()),
      );
    });
  }

  checkUserTypeText({UserDetailsData? details}) {
    Color? widget = Colors.black;

    switch (details!.userType!) {
      case 'Admin':
        {
          widget = Colors.green;
          break;
        }
      case 'Manager':
        {
          widget = Colors.blue;
          break;
        }
      case 'Buyer':
        {
          widget = Colors.orange;
          break;
        }
      case 'Inspector':
        {
          widget = Colors.black;
          break;
        }
      default:
        {
          widget = Colors.green;
          break;
        }
    }
    return widget;
  }

  checkUserTypeBG({UserDetailsData? details}) {
    Color? widget = Colors.black;

    switch (details!.userType!) {
      case 'Admin':
        {
          widget = Colors.green.shade50;
          break;
        }
      case 'Manager':
        {
          widget = Colors.blue.shade100;
          break;
        }
      case 'Buyer':
        {
          widget = Colors.orangeAccent.withOpacity(0.3);
          break;
        }
      case 'Inspector':
        {
          widget = Colors.grey.shade300;
          break;
        }
      default:
        {
          widget = Colors.green.shade50;
          break;
        }
    }
    return widget;
  }

  void showBottomSheet({UserDetailsData? user, bool? isUpdate = false}) {
    if (user != null) {
      fullNameController.text = user.fullName!;
      name = user.fullName!;
      emailController.text = user.email!;
      email = user.email!;
      cityController.text = user.city!;
      city = user.city!;
      zipCodeController.text = user.zipcode!;
      zipCode = user.zipcode!;
      phoneController.text = user.phone!;
      phone = user.phone!;

      try{
        if(-1 == userDropdownItem.indexOf(DropdownModel(user.userId!, user.userType!))){
          dmModel = userDropdownItem[0];
        }
        else{
          if (!["", null].contains(user.userType!)) {
            for (int i = 0; i < userDropdownItem.length; i++) {
              if (userDropdownItem[i].name == user.userType!) {
                dmModel = userDropdownItem[i];
                break;
              }
            }
          }
        }
      }catch(e){
        print(e);
      }

      print(dmModel!.id);
      selectedStatus = user.active!;

      userID = user.userId!;
      deletedUser = user.deleted!;
    }
    Get.bottomSheet(
      AddUserView(
        isUpdateUser: isUpdate,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
    ).then((value) {
      clearData();
    });
  }

  void clearData() {
    fullNameController.clear();
    name = '';
    emailController.clear();
    email = '';
    cityController.clear();
    city = '';
    zipCodeController.clear();
    zipCode = '';
    phoneController.clear();
    phone = '';
    userID = '';
    deletedUser = '';
    password = '';
    passwordController.clear();
    confirmPassword = '';
    confirmPasswordController.clear();

    selectedShortOpt = userFieldShort[1];

    dmModel = userDropdownItem[0];

    isLoading.value = true;
    isProcessStart.value = false;
    sortName = "";
    selectedStatus = userActiveStatusList[1];
  }
/////////////////////////////////////////////////////////////////////////////
}





//--------------------------------------------------- user add view 


class AddUserView extends GetView<UserController> {
  final bool? isUpdateUser;

  AddUserView({this.isUpdateUser});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            formField(
                labelText: Strings.txtFullName,
                helperText: Strings.txtRequired,
                onSave: (value) {
                  controller.name = value!;
                },
                validator: controller.fullNameValid,
                textEditingController: controller.fullNameController,
                keyboardType: TextInputType.text),
            SizedBox(
              height: 10,
            ),
            formField(
                labelText: Strings.txtEmail,
                onSave: (value) {
                  controller.email = value!;
                },
                helperText: Strings.txtRequired,
                validator: controller.emailValid,
                textEditingController: controller.emailController,
                keyboardType: TextInputType.emailAddress),
            SizedBox(
              height: 10,
            ),
            if (isUpdateUser == false) ...[
              formField(
                  labelText: Strings.txtPassword,
                  helperText: Strings.txtRequired,
                  validator: controller.passwordValid,
                  textEditingController: controller.passwordController,
                  onSave: (value) {
                    controller.password = value!;
                  },
                  obscureText: true,
                  keyboardType: TextInputType.text),
              SizedBox(
                height: 10,
              ),
              formField(
                  labelText: Strings.txtConfirmPass,
                  helperText: Strings.txtRequired,
                  //Confirm Password Required. Password must be 8 char long.
                  textEditingController: controller.confirmPasswordController,
                  validator: controller.repeatPasswordValid,
                  onSave: (value) {
                    controller.confirmPassword = value!;
                  },
                  obscureText: true,
                  keyboardType: TextInputType.text),
              SizedBox(
                height: 10,
              ),
            ],

            userDropdown(
              labelText: Strings.txtUserType,
              selectedValue: controller.dmModel,
              helperText: Strings.txtUserType,
              validator: controller.userTypeValid,
              valueChanged: (valueOne){
                controller.dmModel = valueOne;
              },
              onSaved: (value) {
                print(value!.id);
                // controller.dmModel = value;
              },
              items: controller.userDropdownItem,
            ),
            SizedBox(
              height: 10,
            ),
            /* DropdownButtonFormField<dynamic>(
              value: ["",null].contains(controller.selectedType)?null:controller.selectedType,
              icon: Icon(Icons.arrow_drop_down),
              onChanged: (newValue) {
                controller.selectedType = newValue;
                print(newValue + "OnChange");
              },
              onSaved: (val){
                controller.selectedType = val!;
                print(val + "OnSave");
              },

              validator: controller.userTypValid,
              decoration: InputDecoration(
                labelText: "User Type",
                helperText: "Required",
                border: OutlineInputBorder(),
              ),
              items: ![null,""].contains(controller.userTypeListT)
                  ?
              controller.userTypeListT!.map<DropdownMenuItem<dynamic>>
                ((UserTypeList value) {
                return DropdownMenuItem(
                  value: value.userTypeId,
                  child: Text(value.userType!),
                );
              }).toList()
                  :
              null,
            ),*/
            formField(
                labelText: Strings.txtCity,
                onSave: (value) {
                  controller.city = value!;
                },
                textEditingController: controller.cityController,
                keyboardType: TextInputType.text),
            SizedBox(
              height: 10,
            ),
            formField(
                labelText: Strings.txtZipCode,
                helperText: Strings.txtRequired,
                validator: controller.zipCodeValid,
                onSave: (value) {
                  controller.zipCode = value!;
                },
                textEditingController: controller.zipCodeController,
                keyboardType: TextInputType.number),
            SizedBox(
              height: 10,
            ),
            formField(
                labelText: Strings.txtPhone,
                onSave: (value) {
                  controller.phone = value!;
                },
                validator: controller.phoneNumberValid,
                textEditingController: controller.phoneController,
                keyboardType: TextInputType.phone),
            SizedBox(
              height: 10,
            ),
            dropdownWidget(
                labelText: Strings.txtActiveStatus,
                value: controller.selectedStatus,
                helperText: Strings.txtRequired,
                validator: controller.activeStatusValid,
                onSave: (value) {
                  controller.selectedStatus = value!;
                },
                items: controller.userActiveStatusList),

            SizedBox(
              height: 10,
            ),
            OutlinedButton(
              onPressed: () {
                controller.checkFrom(isUpdateAvail: isUpdateUser);
                // _formKey.currentState.reset();
              },
              child: Text(Strings.txtSubmit),
            ).toProgressIndicator(isLoading: controller.isLoading),
          ],
        ).paddingAll(8.0),
      ),
    );
  }

  Widget formField(
          {TextEditingController? textEditingController,
          String? labelText,
          TextInputType? keyboardType,
          Function(String?)? onSave,
          FormFieldValidator<String>? validator,
          String? helperText,
          FocusNode? focusNode,
          bool obscureText = false}) =>
      TextFormField(
        focusNode: focusNode,
        obscureText: obscureText,
        controller: textEditingController,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: labelText,
          helperText: helperText,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
        ),
        onSaved: onSave,
        validator: validator,
      );

  Widget dropdownWidget(
      {String? labelText,
      String? errorText,
      String? helperText,
      String? value,
      Function(String?)? onSave,
      FormFieldValidator<String>? validator,
      required List<String> items}) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: Icon(Icons.arrow_drop_down),
      onChanged: (String? newValue) {
        value = newValue;
      },
      onSaved: onSave,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        helperText: helperText,
        border: OutlineInputBorder(),
      ),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget userDropdown(
      {labelText,
      errorText,
      helperText,
      selectedValue,
        valueChanged,
      Function(dynamic)? onSaved,
      FormFieldValidator? validator,
      required List<dynamic> items}) {
    return DropdownButtonFormField<dynamic>(
        decoration: InputDecoration(
          labelText: labelText,
          helperText: helperText,
          border: OutlineInputBorder(),
        ),
        value: selectedValue,
        items: items.map((e) {
          return DropdownMenuItem(
            child: Text(e.name),
            value: e,
          );
        }).toList(),
        onSaved: onSaved,
        validator: validator,
        onChanged: valueChanged ?? (newValue) {
          selectedValue = newValue!;
        });
  }
}

//--------------------------------------------------------user List view

import 'package:buy_smart/app/custom_view/alert_dialog_view.dart';
import 'package:buy_smart/app/custom_view/error_view.dart';
import 'package:buy_smart/app/data/api_models/user_list_model.dart';
import 'package:buy_smart/app/data/resources/string/string.dart';
import 'package:buy_smart/app/modules/user/controllers/user_controller.dart';
import 'package:buy_smart/app/modules/user/views/user_filter_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserView extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.txtUserList),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(6.0),
          child: linearProgressBar(5.0),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                    onPressed: (){
                      controller.isProcessStart.value = true;
                      controller.browseUserList();
                    },
                    icon: Icon(Icons.refresh_outlined)
                ),
                IconButton(
                    onPressed: () {
                      Get.defaultDialog(
                              title: Strings.txtUserFilter, content: UserFilterView())
                          .then((value) {
                        controller.clearData();
                      });
                    },
                    icon: Icon(
                      Icons.sort,
                    )),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          controller.clearData();
          controller.showBottomSheet();
        },
      ),
      body: controller.obx(
        (data) {
          controller.userDetailList = data as List<UserDetailsData>;
          return Container(
            color: Colors.grey.shade300,
            height: MediaQuery.of(context).size.height / 1,
            child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: controller.userDetailList!.length,
                itemBuilder: (_, int index) {
                  UserDetailsData details = controller.userDetailList![index];
                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: textWidget(
                              text: details.fullName!,
                              fontWidget: FontWeight.bold),
                          subtitle: textWidget(text: details.email!),
                        ),
                        Divider(
                          height: 4.0,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FittedBox(
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.phone_enabled_outlined,
                                      size: 18.0,
                                    ),
                                  ),
                                  textWidget(
                                    text: details.phone!,
                                    textSize: 15.0,
                                  ),
                                ],
                              ),
                            ),
                            Chip(
                              label: textWidget(
                                text: details.userType!,
                                textSize: 14.0,
                                colorName:
                                controller.checkUserTypeText(details: details)
                              ),
                              backgroundColor:
                                  controller.checkUserTypeBG(details: details),
                            )
                          ],
                        ),
                        Divider(
                          height: 10.0,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(4.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      Strings.txtUserFilter,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black54),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 4.0),
                                      child: textWidget(
                                        text: details.city!,
                                        textSize: 14.0,
                                      ),
                                    )
                                  ],
                                )),
                            Container(
                                padding: EdgeInsets.all(4.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      Strings.txtZipCode,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black54),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 4.0),
                                      child: textWidget(
                                        text: details.zipcode!,
                                        textSize: 14.0,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        Divider(
                          height: 10.0,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                              label: textWidget(
                                  text: Strings.txtView,
                                  textSize: 14.0,
                                  colorName: Colors.green),
                              onPressed: () {},
                              icon: Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.green,
                              ),
                            ),
                            TextButton.icon(
                              icon: Icon(
                                Icons.edit_outlined,
                              ),
                              onPressed: () {
                                controller.showBottomSheet(user: details, isUpdate: true);
                              },
                              label: textWidget(text: Strings.txtEdit, textSize: 14.0),
                            ),
                            TextButton.icon(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                Get.defaultDialog(
                                    content: AlertView(
                                      alertText: details.fullName!,
                                      onChangeYes: () {
                                        controller.removeUser(
                                            userID: details.userId);
                                      },
                                      onChangeNo: () {
                                        Get.back();
                                      },
                                    ),
                                    title: "");
                              },
                              label: textWidget(
                                  text: Strings.txtDelete,
                                  textSize: 14.0,
                                  colorName: Colors.redAccent),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          );
        },
        onError: (error) => Center(
          child: ErrorView(
            errorText: error!,
            function: () {
              Get.back();
            },
          ),
        ),
      ),
    );
  }



  Widget textWidget(
      {String? text,
      double? textSize,
      Color? colorName,
      FontWeight? fontWidget,
      FontStyle? fontStyle}) {
    return Text(
      text!,
      softWrap: true,
      style: TextStyle(
        fontSize: textSize,
        color: colorName,
        fontWeight: fontWidget,
        fontStyle: fontStyle,
      ),
    );
  }

  linearProgressBar(_height) {
    return Obx((){
      if (controller.isProcessStart.value != true) {
        return Container(
          height: _height,
          width: Get.width,
        );
      }
      return PreferredSize(
        child: SizedBox(
          width: double.infinity,
          height: _height,
          child: LinearProgressIndicator(),
        ),
        preferredSize: const Size.fromHeight(0),
      );
    });
  }
}


//----------------------------------------- model


// To parse this JSON data, do
//
//     final getUserListModel = getUserListModelFromJson(jsonString);

import 'dart:convert';

GetUserListModel getUserListModelFromJson(String str) => GetUserListModel.fromJson(json.decode(str));

String getUserListModelToJson(GetUserListModel data) => json.encode(data.toJson());

class GetUserListModel {
  GetUserListModel({
    this.status,
    this.statuscode,
    this.message,
    this.totalrecords,
    this.data,
  });

  final String? status;
  final String? statuscode;
  final String? message;
  final int? totalrecords;
  final List<UserDetailsData>? data;

  factory GetUserListModel.fromJson(Map<String, dynamic> json) => GetUserListModel(
    status: json["STATUS"] == null ? null : json["STATUS"],
    statuscode: json["STATUSCODE"] == null ? null : json["STATUSCODE"],
    message: json["MESSAGE"] == null ? null : json["MESSAGE"],
    totalrecords: json["TOTALRECORDS"] == null ? null : json["TOTALRECORDS"],
    data: json["DATA"] == null ? null : List<UserDetailsData>.from(json["DATA"].map((x) => UserDetailsData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "STATUS": status == null ? null : status,
    "STATUSCODE": statuscode == null ? null : statuscode,
    "MESSAGE": message == null ? null : message,
    "TOTALRECORDS": totalrecords == null ? null : totalrecords,
    "DATA": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class UserDetailsData {
  UserDetailsData({
    this.userId,
    this.fullName,
    this.email,
    this.phone,
    this.city,
    this.zipcode,
    this.active,
    this.deleted,
    this.userType,
  });

  final String? userId;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? city;
  final String? zipcode;
  final String? active;
  final String? deleted;
  final String? userType;

  factory UserDetailsData.fromJson(Map<String, dynamic> json) => UserDetailsData(
    userId: json["UserID"] == null ? null : json["UserID"],
    fullName: json["FullName"] == null ? null : json["FullName"],
    email: json["Email"] == null ? null : json["Email"],
    phone: json["Phone"] == null ? null : json["Phone"],
    city: json["City"] == null ? null : json["City"],
    zipcode: json["Zipcode"] == null ? null : json["Zipcode"],
    active: json["Active"] == null ? null : json["Active"],
    deleted: json["Deleted"] == null ? null : json["Deleted"],
    userType: json["UserType"] == null ? null : json["UserType"],
  );

  Map<String, dynamic> toJson() => {
    "UserID": userId == null ? null : userId,
    "FullName": fullName == null ? null : fullName,
    "Email": email == null ? null : email,
    "Phone": phone == null ? null : phone,
    "City": city == null ? null : city,
    "Zipcode": zipcode == null ? null : zipcode,
    "Active": active == null ? null : active,
    "Deleted": deleted == null ? null : deleted,
    "UserType": userType == null ? null : userType,
  };
}



//--------------------------------------------------------------api call method


  ///GetUserType
  static Future getUserType({Map<String, dynamic>? body})async{
    final response = await http.post(
      Uri.parse(Strings.txtBase_URL+Strings.txtAGetUserType),
      body: body!,
    );
    try{
      if(response.statusCode == 200){
        return response.body;
      }
      if(response.statusCode == 401){
        return throw Exception(Strings.txtEHappenWrong);
      }
    } catch(error) {
      print(error);
      return Future.error(error);
    }
  }



