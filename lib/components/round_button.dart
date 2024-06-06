import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final VoidCallback onpressed;
  final String text;
  final Color backgroundcolor;
  final bool loading;
  final double height, width;
  final double borderradius;

  const RoundButton(
      {super.key,
      required this.onpressed,
      required this.text,
      this.backgroundcolor = Colors.purple,
      this.loading = false,
      this.height = 50,
      this.width = 150,
      this.borderradius = 30});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onpressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderradius)),
          backgroundColor: backgroundcolor,
        ),
        child: loading
            ? CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
                backgroundColor: Colors.black,
                strokeCap: StrokeCap.round,
              )
            : Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Colors.white),
              ),
      ),
    );
  }
}
