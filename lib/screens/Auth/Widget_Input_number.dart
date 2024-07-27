import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNumberInput extends StatefulWidget {
  TextEditingController controller;


  final ValueChanged<bool> onInputValidated;

  PhoneNumberInput({super.key, required this.controller, required this.onInputValidated});

  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState(controller: controller);
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  _PhoneNumberInputState({required this.controller});
  PhoneNumber number = PhoneNumber(isoCode: 'MA');
  TextEditingController controller;
  final FocusNode focusNodeNumber = FocusNode();
  bool _isFocused1 = false;
  bool isValid=false;
  @override
  void initState() {
    super.initState();
    focusNodeNumber.addListener(() {
      setState(() {
        _isFocused1 = focusNodeNumber.hasFocus;
      });
    });

  }

  @override
  void dispose() {
    focusNodeNumber.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        print('Phone number changed: ${number.phoneNumber}');
      },
      onInputValidated: (bool value) {
        print('Is phone number valid: $value');
        setState(() {
          widget.onInputValidated(value);
          isValid=value;
        });
      },
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.DROPDOWN,
        showFlags: true,
        setSelectorButtonAsPrefixIcon: true,
        trailingSpace: false,
      ),
      ignoreBlank: false,
      autoFocus: true,
      focusNode: focusNodeNumber,
      textFieldController: controller,
      formatInput: false,
      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
      initialValue: number,
      maxLength: 9,
      validator: (p0) {
        setState(() {

        });
      },
      countries: ['MA', 'US', 'FR', 'IT', 'ES'], // Focus on Morocco
      inputDecoration: InputDecoration(
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: isValid?const Icon(Icons.phone_android_sharp):const Icon(Icons.phonelink_erase),
        ),
        hintText: "0000-00-000",
        filled: true,
        fillColor: _isFocused1
            ? const Color(0xffEBEBFF)
            : isValid?const Color(0xfff7f7f9):const Color(0xffFFE8E8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(
            width: 0,
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(
            width: 0,
            color: Colors.transparent,
          ),
        ),
        contentPadding:
        EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      ),
      onSaved: (PhoneNumber number) {
        print('Phone number saved: ${number.phoneNumber}');
      },
    );
  }
}
