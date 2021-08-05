import 'package:flutter/material.dart';

import 'package:get/get.dart';

// here use pakage
//google_sign_in: ^5.0.3 
// get: 

class AddUserView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(8.0),
        children: [
          SizedBox(
            height: 10,
          ),
          formField(
              labelText: 'Email',
              onSave: (value) {
                controller.email = value!;
              },
              helperText: 'Required',
              validator: controller.emailValid,
              textEditingController: controller.emailController,
              keyboardType: TextInputType.emailAddress),
          SizedBox(
            height: 10,
          ),
          formField(
              labelText: 'Full Name',
              helperText: "Required",
              onSave: (value) {
                controller.name = value!;
              },
              validator: controller.fullNameValid,
              textEditingController: controller.fullNameController),
          SizedBox(
            height: 10,
          ),
          formField(
              labelText: 'Full Name',
              helperText: "Required",
              onSave: (value) {
                controller.name1 = value!;
              },
              validator: controller.fullNameValid1,
              keyboardType: TextInputType.emailAddress,
              textEditingController: controller.fullNameController1),
          SizedBox(
            height: 10,
          ),
          formField(
              labelText: 'Password',
              helperText: 'Required',
              validator: controller.passwordValid,
              textEditingController: controller.passwordController,
              onSave: (value) {
                controller.password = value!;
              },
              obscureText: true),
          SizedBox(
            height: 10,
          ),
          formField(
              labelText: 'confirm Password',
              helperText: 'Required',
              //Confirm Password Required. Password must be 8 char long.
              textEditingController: controller.confirmPasswordController,
              validator: controller.passwordValid,
              onSave: (value) {
                controller.confirmPassword = value!;
              },
              obscureText: true),
          SizedBox(
            height: 10,
          ),
          userDropdown(
              labelText: "User Type",
              value: controller.userType,
              helperText: 'Required',
              validator: controller.userTypeValid,
              onSave: (value) {
                controller.userType = value!;
              },
              items: controller.userTypeList),
          SizedBox(
            height: 10,
          ),
          formField(
              labelText: 'City',
              onSave: (value) {
                controller.city = value!;
              },
              textEditingController: controller.cityController),
          SizedBox(
            height: 10,
          ),
          formField(
              labelText: 'Zipcode ',
              helperText: 'Required',
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
              labelText: 'Phone',
              onSave: (value) {
                controller.phone = value!;
              },
              textEditingController: controller.phoneController,
              keyboardType: TextInputType.phone),
          SizedBox(
            height: 10,
          ),
          OutlinedButton(
            onPressed: () {
              controller.checkFrom();
              // _formKey.currentState.reset();
            },
            child: Text('Submit'),
          ),
        ],
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
          bool obscureText = false}) =>
      TextFormField(
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
        /* onFieldSubmitted: (term) {
          print(term);
        },*/
      );

  Widget userDropdown(
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
}
