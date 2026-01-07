import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/build_extention.dart';

class OtpFields extends StatefulWidget {
  final int length;
  final void Function(String code) onCompleted;

  const OtpFields({
    super.key,
    this.length = 6,
    required this.onCompleted,
  });

  @override
  State<OtpFields> createState() => _OtpFieldsState();
}

class _OtpFieldsState extends State<OtpFields> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();

    controllers = List.generate(widget.length, (_) => TextEditingController());
    focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in controllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
  }

  void handleInput(int index, String value) {
    if (value.length > 1) {
      // pasted code
      pasteOtp(value);
      return;
    }

    if (value.isNotEmpty && index < widget.length - 1) {
      focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }

    checkComplete();
  }

  void pasteOtp(String value) {
    final paste = value.trim().replaceAll(RegExp(r'\D'), '');

    for (var i = 0; i < widget.length; i++) {
      controllers[i].text = i < paste.length ? paste[i] : '';
    }

    if (paste.length == widget.length) {
      focusNodes.last.unfocus();
      widget.onCompleted(paste);
    }
    setState(() {});
  }

  void checkComplete() {
    final code = controllers.map((c) => c.text).join();
    if (code.length == widget.length) {
      widget.onCompleted(code);
      focusNodes.last.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: context.width/8.4,
          height: context.width/8.4,
          child: TextFormField(
            controller: controllers[index],
            focusNode: focusNodes[index],

            onChanged: (value) => handleInput(index, value),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 2),
              counterText: "",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.kGrey1,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.kGrey1,
                  width: 1,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
