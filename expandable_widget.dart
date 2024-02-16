
import 'package:flutter/material.dart';

class ExpandableWidget extends StatefulWidget {

  final Widget header;
  final Widget child;
  final Curve curve;
  final int duration;

  const ExpandableWidget(
      {
        super.key,
        required this.header,
        required this.child,
        this.curve = Curves.fastLinearToSlowEaseIn,
        this.duration = 200
      }
      );

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> with TickerProviderStateMixin {
  late final AnimationController _headerAnimationController;
  late final Animation<double> _headerAnimation;

  late final AnimationController _childAnimationController;
  late final Animation<double> _childAnimation;

  late final Tween<double> _sizeTween = Tween(begin: 0, end: 1);

  var isExpanded = false;
  var isFirstTap = true;

  @override
  void initState() {

    _headerAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration)
    );

    _headerAnimation = CurvedAnimation(
        parent: _headerAnimationController,
        curve: widget.curve
    );

    _childAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.duration)
    );

    _childAnimation = CurvedAnimation(
        parent: _childAnimationController,
        curve: widget.curve
    );

    super.initState();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _childAnimationController.dispose();
    super.dispose();
  }

  void _expandOnChanged() {  /// This method is triggered on tap
    isFirstTap = false;
    setState(() {
      isExpanded = !isExpanded;
    });

    isExpanded ?
         _headerAnimationController.forward() : _headerAnimationController.reverse();

    isExpanded ?
        _childAnimationController.reverse() : _childAnimationController.forward();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _expandOnChanged,
          child: isFirstTap ? widget.header : !isExpanded ?
            SizeTransition(
              sizeFactor: _sizeTween.animate(_childAnimation),
              child: widget.header,
            ) :
            SizeTransition(
                sizeFactor: _sizeTween.animate(_headerAnimation),
                child: widget.child,
            ),
        )
      ],
    );
  }


}
