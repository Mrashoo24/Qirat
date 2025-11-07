import 'package:eshop/core/router/new_web_router.dart';
import 'package:eshop/data/models/user/user_model.dart';
import 'package:eshop/presentation/blocs/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constant/images.dart';
import '../../../../../data/models/user/delivery_info_model.dart';
import '../../../../../domain/entities/user/delivery_info.dart';
import '../../../../../core/theme/qirat_theme.dart';
import '../../../widgets/delivery_info_card.dart';
import '../../../widgets/input_form_button.dart';
import '../../../widgets/input_text_form_field.dart';

class DeliveryInfoViewNew extends StatefulWidget {
  const DeliveryInfoViewNew({Key? key}) : super(key: key);

  @override
  State<DeliveryInfoViewNew> createState() => _DeliveryInfoViewNewState();
}

class _DeliveryInfoViewNewState extends State<DeliveryInfoViewNew> {
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
      child: Theme(
        data: QiratTheme.darkTheme,
        child: Scaffold(
          backgroundColor: QiratTheme.darkBackground,
          appBar: AppBar(
            backgroundColor: QiratTheme.darkBackground,
            foregroundColor: QiratTheme.darkOnBackground,
            elevation: 0,
            title: const Text("Delivery Details",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                )),
          ),
          body: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is! UserLogged) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(kEmptyDeliveryInfo),
                    const SizedBox(height: 8),
                    const Text(
                      "Delivery information are Empty!",
                      style: TextStyle(
                        color: QiratTheme.textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    )
                  ],
                );
              }
              return ListView.builder(
                itemCount: state.user.deliveryInfos.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemBuilder: (context, index) => DeliveryInfoCard(
                  deliveryInformation: state.user.deliveryInfos[index],
                  isSelected: state.user.deliveryInfos[index].isSelected,
                  onTap: () {
                    updateDeliveryInfo(UserModel.fromEntity(state.user),
                        context, state.user.deliveryInfos[index]);
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
                  backgroundColor: QiratTheme.qiratGold,
                  onPressed: () {
                    if (state is! UserLogged) {
                      context.goNamed(NewWebRouter.newSignIn);
                    } else {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: QiratTheme.darkSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        builder: (BuildContext context) {
                          return DeliveryInfoForm(state: state);
                        },
                      );
                    }
                  },
                  tooltip: 'Add Delivery Info',
                  child: const Icon(
                    Icons.add,
                    color: QiratTheme.qiratBlack,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void updateDeliveryInfo(
      UserModel userModel, BuildContext context, DeliveryInfo deliveryInfo) {
    // Update all other delivery infos in the list
    var updateDeliveryInfoList = userModel.deliveryInfos.map((element) {
      if (element.id == deliveryInfo.id) {
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
          deliveryInfos: updateDeliveryInfoList,
          token: userModel.token,
        )));
    context.pop();
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
      // Strip '+' for the input field; UI shows '+' as prefix and we add it back when saving
      contactNumber.text =
          widget.deliveryInfo!.contactNumber.replaceAll('+', '');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: QiratTheme.darkTheme,
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                        const SizedBox(height: 24),
                        Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: QiratTheme.goldBorder,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Delivery Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: QiratTheme.darkOnBackground,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // First name
                        InputTextFormField(
                          controller: firstName,
                          hint: 'First name',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          validation: (val) =>
                              (val == null || val.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 10),
                        // Last name
                        InputTextFormField(
                          controller: lastName,
                          hint: 'Last name',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          validation: (val) =>
                              (val == null || val.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 10),
                        // Address line one
                        InputTextFormField(
                          controller: addressLineOne,
                          hint: 'Address line one',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          validation: (val) =>
                              (val == null || val.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 10),
                        // Address line two
                        InputTextFormField(
                          controller: addressLineTwo,
                          hint: 'Address line two',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          validation: (val) =>
                              (val == null || val.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 10),
                        // City
                        InputTextFormField(
                          controller: city,
                          hint: 'City',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          validation: (val) =>
                              (val == null || val.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 10),
                        // Pincode
                        InputTextFormField(
                          controller: zipCode,
                          hint: 'Pincode (6 digits)',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          validation: (val) {
                            if (val == null || val.isEmpty)
                              return 'Pincode required';
                            if (!RegExp(r'^\d{6}$').hasMatch(val.trim()))
                              return 'Enter exactly 6 digits';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        // Phone number with country code (digits only; '+' provided as prefix)
                        InputTextFormField(
                          controller: contactNumber,
                          hint: 'Country code + number (e.g. 91XXXXXXXXXX)',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          prefix: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('+',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(15),
                          ],
                          validation: (val) {
                            if (val == null || val.isEmpty)
                              return 'Phone required';
                            final d = val.trim();
                            if (d.length < 8 || d.length > 15)
                              return 'Enter 8-15 digits incl. country code';
                            if (!RegExp(r'^\d+$').hasMatch(d))
                              return 'Digits only';
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        InputFormButton(
                          color: QiratTheme.qiratGold,
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
                                  id: concatenatedProperties.hashCode
                                      .toString(),
                                  firstName: firstName.text,
                                  lastName: lastName.text,
                                  addressLineOne: addressLineOne.text,
                                  addressLineTwo: addressLineTwo.text,
                                  city: city.text,
                                  zipCode: zipCode.text,
                                  contactNumber:
                                      '+${contactNumber.text.trim()}',
                                  isSelected:
                                      true, // The new delivery info is selected
                                );

                                updateDeliveryInfo(
                                    userModel, context, newDeliveryInfo);

                                // context.read<UserBloc>().add(UpdateUser(UserModel(
                                //     id: userModel.id,
                                //     firstName: userModel.firstName,
                                //     lastName: userModel.lastName,
                                //     email: userModel.email,
                                //     deliveryInfos: [...widget.state.user.deliveryInfos,newDeliveryInfo])));
                              } else {
                                updateDeliveryInfo(
                                    userModel, context, widget.deliveryInfo);
                              }
                              // context.pop();
                            }
                          },
                          titleText:
                              widget.deliveryInfo == null ? 'Save' : 'Update',
                        ),
                        const SizedBox(height: 8),
                        InputFormButton(
                          color: QiratTheme.darkSurfaceVariant,
                          onClick: () {
                            context.pop();
                          },
                          titleText: 'Cancel',
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateDeliveryInfo(
      UserModel userModel, BuildContext context, DeliveryInfo? deliveryInfo) {
    var newDeliveryInfo = DeliveryInfoModel(
      id: deliveryInfo!.id,
      firstName: firstName.text,
      lastName: lastName.text,
      addressLineOne: addressLineOne.text,
      addressLineTwo: addressLineTwo.text,
      city: city.text,
      zipCode: zipCode.text,
      contactNumber: '+${contactNumber.text.trim()}',
      isSelected: true, // The new delivery info is selected
    );

    var isNewInfo = userModel.deliveryInfos
        .where((element) => element.id == deliveryInfo.id)
        .isEmpty;

    // Update all other delivery infos in the list
    var updateDeliveryInfoList = userModel.deliveryInfos.map((element) {
      if (element.id == deliveryInfo.id) {
        // Update the selected delivery info
        return newDeliveryInfo;
      } else {
        // Set isSelected to false for all other delivery infos
        return element.copyWith(isSelected: false);
      }
    }).toList();

    if (isNewInfo) {
      updateDeliveryInfoList.add(newDeliveryInfo);
    }

    context.read<UserBloc>().add(UpdateUser(UserModel(
        id: userModel.id,
        firstName: userModel.firstName,
        lastName: userModel.lastName,
        email: userModel.email,
        deliveryInfos: updateDeliveryInfoList,
        token: userModel.token)));

    Navigator.pop(context);
  }
}
