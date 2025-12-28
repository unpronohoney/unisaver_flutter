import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:unisaver_flutter/constants/colors.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/dialogs/info_and_bottom_sheet.dart';

class MainPageButton extends StatefulWidget {
  final int function;
  const MainPageButton({super.key, required this.function});

  @override
  State<StatefulWidget> createState() => StateMainPageButton();
}

class StateMainPageButton extends State<MainPageButton> {
  bool _show = false;

  @override
  Widget build(BuildContext context) {
    String text = widget.function > 1
        ? widget.function == 2
              ? t(context).main_btns2
              : t(context).main_btns3
        : t(context).main_btns1;
    IconData icon = widget.function > 1
        ? widget.function == 2
              ? Icons.account_tree_outlined
              : Icons.document_scanner_outlined
        : Icons.calculate_outlined;
    final orientation = MediaQuery.of(context).orientation;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack,
        child: AnimatedSwitcher(
          key: ValueKey(orientation),
          duration: const Duration(microseconds: 2000),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: _show
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.primaryFixed,
                    border: BoxBorder.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.niceBlack.withValues(alpha: 0.5),
                        blurRadius: 12,
                        offset: const Offset(0, 6), // Aşağı doğru hafif gölge
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              icon,
                              color: Theme.of(context).colorScheme.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              text,
                              style: TextStyle(
                                fontFamily: 'MontserratAlternates',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _show = false;
                              });
                            },
                            icon: Icon(
                              Icons.close_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.light
                                  ? AppColors.whiteish.withValues(alpha: 0.5)
                                  : AppColors.niceBlack.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: LottieBuilder.asset(
                                widget.function > 1
                                    ? widget.function == 2
                                          ? 'assets/Algorithm.json'
                                          : 'assets/transcript.json'
                                    : 'assets/Calculator.json',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.function > 1
                                  ? widget.function == 2
                                        ? t(context).combination_desc
                                        : t(context).transcript_desc
                                  : t(context).manuel_desc,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'Roboto',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                            child: InkWell(
                              onTap: () {
                                if (widget.function == 1) {
                                  Navigator.pushNamed(context, '/manuel');
                                } else if (widget.function == 2) {
                                  Navigator.pushNamed(context, '/combination');
                                } else {
                                  Navigator.pushNamed(context, '/transcript');
                                }
                              },
                              child: Ink(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.niceBlack.withValues(alpha: 0.5),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryFixed,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: Theme.of(
                                  context,
                                ).colorScheme.secondary.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (widget.function == 1) {
                              Navigator.pushNamed(context, '/manuel');
                            } else if (widget.function == 2) {
                              Navigator.pushNamed(context, '/combination');
                            } else {
                              Navigator.pushNamed(context, '/transcript');
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  icon,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Flexible(
                                child: Text(
                                  text,
                                  style: TextStyle(
                                    fontFamily: 'MontserratAlternates',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    height: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    infoButton(context, () {
                      setState(() {
                        _show = true;
                      });
                    }),
                  ],
                ),
        ),
      ),
    );
  }
}
