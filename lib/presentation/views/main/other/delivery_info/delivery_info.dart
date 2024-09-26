import 'package:eshop/data/models/user/user_model.dart';
import 'package:eshop/presentation/blocs/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../../core/constant/images.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../data/models/user/delivery_info_model.dart';
import '../../../../../domain/entities/user/delivery_info.dart';
import '../../../../blocs/delivery_info/delivery_info_action/delivery_info_action_cubit.dart';
import '../../../../blocs/delivery_info/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import '../../../../widgets/delivery_info_card.dart';
import '../../../../widgets/input_form_button.dart';
import '../../../../widgets/input_text_form_field.dart';

class DeliveryInfoView extends StatefulWidget {
  const DeliveryInfoView({Key? key}) : super(key: key);

  @override
  State<DeliveryInfoView> createState() => _DeliveryInfoViewState();
}

class _DeliveryInfoViewState extends State<DeliveryInfoView> {
  @override
  Widget build(BuildContext context) {


    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        // EasyLoading.dismiss();
        // if (state is UserLogged) {
        //   EasyLoading.show(status: 'Loading...');
        // } else if (state is DeliveryInfoSelectActionSuccess) {
        //   context
        //       .read<DeliveryInfoFetchCubit>()
        //       .selectDeliveryInfo(state.deliveryInfo);
        // } else if (state is DeliveryInfoActionFail) {
        //   EasyLoading.showError("Error");
        // }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Delivery Details"),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is! UserLogged) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(kEmptyDeliveryInfo),
                  const Text("Delivery information are Empty!"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  )
                ],
              );
            }
            return ListView.builder(
              itemCount: state.user.deliveryInfos.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemBuilder: (context, index) => DeliveryInfoCard(
                deliveryInformation: state.user.deliveryInfos[index],
                isSelected: state.user.deliveryInfos[index].isSelected,
                onTap: (){
                  updateDeliveryInfo(UserModel.fromEntity(state.user), context,state.user.deliveryInfos[index]);
                },
              ),
            );
          },
        ),
        floatingActionButton:
            BlocBuilder<UserBloc, UserState>(builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () {
                  if (state is! UserLogged) {
                    Navigator.of(context).pushNamed(AppRouter.signIn);
                  } else {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      builder: (BuildContext context) {
                        return  DeliveryInfoForm(state:state);
                      },
                    );
                  }
                },
                tooltip: 'Increment',
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }),
      ),
    );


  }
  void updateDeliveryInfo(UserModel userModel, BuildContext context,DeliveryInfo deliveryInfo) {
    // Update all other delivery infos in the list
    var updateDeliveryInfoList =
    userModel.deliveryInfos.map((element) {
      if (element.id == deliveryInfo?.id) {
        // Update the selected delivery info
        return element.copyWith(isSelected: true);
      } else {
        // Set isSelected to false for all other delivery infos
        return element.copyWith(isSelected: false);
      }
    }).toList();

    context.read<UserBloc>().add(UpdateUser(UserModel(
        id: userModel.id,
        firstName: userModel.firstName,
        lastName: userModel.lastName,
        email: userModel.email,
        deliveryInfos: updateDeliveryInfoList, token: userModel.token,)));
    Navigator.pop(context);
  }

}

class DeliveryInfoForm extends StatefulWidget {
  final DeliveryInfo? deliveryInfo;
  final UserLogged state;
  const DeliveryInfoForm({
    super.key,
    this.deliveryInfo,
    required this.state,
  });

  @override
  State<DeliveryInfoForm> createState() => _DeliveryInfoFormState();
}

class _DeliveryInfoFormState extends State<DeliveryInfoForm> {
  String? id;
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController addressLineOne = TextEditingController();
  final TextEditingController addressLineTwo = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController zipCode = TextEditingController();
  final TextEditingController contactNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.deliveryInfo != null) {
      id = widget.deliveryInfo!.id;
      firstName.text = widget.deliveryInfo!.firstName;
      lastName.text = widget.deliveryInfo!.lastName;
      addressLineOne.text = widget.deliveryInfo!.addressLineOne;
      addressLineTwo.text = widget.deliveryInfo!.addressLineTwo;
      city.text = widget.deliveryInfo!.city;
      zipCode.text = widget.deliveryInfo!.zipCode;
      contactNumber.text = widget.deliveryInfo!.contactNumber;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {

          // EasyLoading.dismiss();
          // if (state is DeliveryInfoActionLoading) {
          //   EasyLoading.show(status: 'Loading...');
          // } else if (state is DeliveryInfoAddActionSuccess) {
          //   Navigator.of(context).pop();
          //   context
          //       .read<DeliveryInfoFetchCubit>()
          //       .addDeliveryInfo(state.deliveryInfo);
          //   EasyLoading.showSuccess("Delivery info successfully added!");
          // } else if (state is DeliveryInfoEditActionSuccess) {
          //   Navigator.of(context).pop();
          //   context
          //       .read<DeliveryInfoFetchCubit>()
          //       .editDeliveryInfo(state.deliveryInfo);
          //   EasyLoading.showSuccess("Delivery info successfully edited!");
          // } else if (state is DeliveryInfoActionFail) {
          //   EasyLoading.showError("Error");
          // }
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 50,
                      ),
                      InputTextFormField(
                        controller: firstName,
                        hint: 'First name',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        validation: (String? val) {
                          if (val == null || val.isEmpty) {
                            return 'This field can\'t be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InputTextFormField(
                        controller: lastName,
                        hint: 'Last name',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        validation: (String? val) {
                          if (val == null || val.isEmpty) {
                            return 'This field can\'t be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InputTextFormField(
                        controller: addressLineOne,
                        hint: 'Address line one',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        validation: (String? val) {
                          if (val == null || val.isEmpty) {
                            return 'This field can\'t be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InputTextFormField(
                        controller: addressLineTwo,
                        hint: 'Address line two',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        validation: (String? val) {
                          if (val == null || val.isEmpty) {
                            return 'This field can\'t be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InputTextFormField(
                        controller: city,
                        hint: 'City',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        validation: (String? val) {
                          if (val == null || val.isEmpty) {
                            return 'This field can\'t be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InputTextFormField(
                        controller: zipCode,
                        hint: 'Zip code',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        validation: (String? val) {
                          if (val == null || val.isEmpty) {
                            return 'This field can\'t be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      InputTextFormField(
                        controller: contactNumber,
                        hint: 'Contact number',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        validation: (String? val) {
                          if (val == null || val.isEmpty) {
                            return 'This field can\'t be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      InputFormButton(
                        color: Colors.black87,
                        onClick: () {
                          UserModel userModel =
                              UserModel.fromEntity(widget.state.user);

                          if (_formKey.currentState!.validate()) {
                            if (widget.deliveryInfo == null) {
                              var concatenatedProperties = firstName.text +
                                  lastName.text +
                                  addressLineOne.text +
                                  addressLineTwo.text +
                                  city.text +
                                  zipCode.text +
                                  contactNumber.text;

                              var newDeliveryInfo = DeliveryInfoModel(
                                id: concatenatedProperties.hashCode.toString(),
                                firstName: firstName.text,
                                lastName: lastName.text,
                                addressLineOne: addressLineOne.text,
                                addressLineTwo: addressLineTwo.text,
                                city: city.text,
                                zipCode: zipCode.text,
                                contactNumber: contactNumber.text,
                                isSelected:
                                true, // The new delivery info is selected
                              );


                              updateDeliveryInfo(userModel, context,newDeliveryInfo);

                              // context.read<UserBloc>().add(UpdateUser(UserModel(
                              //     id: userModel.id,
                              //     firstName: userModel.firstName,
                              //     lastName: userModel.lastName,
                              //     email: userModel.email,
                              //     deliveryInfos: [...widget.state.user.deliveryInfos,newDeliveryInfo])));
                            } else {
                              updateDeliveryInfo(userModel, context,widget.deliveryInfo);
                            }
                            Navigator.of(context).pop();
                          }
                        },
                        titleText: widget.deliveryInfo == null ? 'Save' : 'Update',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      InputFormButton(
                        color: Colors.black87,
                        onClick: () {
                          Navigator.of(context).pop();
                        },
                        titleText: 'Cancel',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateDeliveryInfo(UserModel userModel, BuildContext context,DeliveryInfo? deliveryInfo) {
    var newDeliveryInfo = DeliveryInfoModel(
      id: deliveryInfo!.id,
      firstName: firstName.text,
      lastName: lastName.text,
      addressLineOne: addressLineOne.text,
      addressLineTwo: addressLineTwo.text,
      city: city.text,
      zipCode: zipCode.text,
      contactNumber: contactNumber.text,
      isSelected:
          true, // The new delivery info is selected
    );

    var isNewInfo =  userModel.deliveryInfos.where((element) => element.id == deliveryInfo.id).isEmpty;


    // Update all other delivery infos in the list
    var updateDeliveryInfoList =
        userModel.deliveryInfos.map((element) {
      if (element.id == deliveryInfo?.id) {
        // Update the selected delivery info
        return newDeliveryInfo;
      } else {
        // Set isSelected to false for all other delivery infos
        return element.copyWith(isSelected: false);
      }
    }).toList();

    if(isNewInfo){
      updateDeliveryInfoList.add(newDeliveryInfo);
    }

    context.read<UserBloc>().add(UpdateUser(UserModel(
        id: userModel.id,
        firstName: userModel.firstName,
        lastName: userModel.lastName,
        email: userModel.email,
        deliveryInfos: updateDeliveryInfoList,token: userModel.token)));

    Navigator.pop(context);
  }
}
