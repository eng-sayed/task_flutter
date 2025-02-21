import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/extensions/all_extensions.dart';
import '../../shared/widgets/text_widget.dart';


class CustomAutoCompleteTextField<T> extends StatefulWidget {
  const CustomAutoCompleteTextField(
      {Key? key,
      this.initialValue,
      this.lable,
      this.showClearIcon = false,
      this.showSufix = false,
      this.showLabel = false,
      this.showRequiredStar = false,
      this.keepSuggestionAftertSelect = false,
      this.removeSelectedItem = false,
      required this.onChanged,
      this.onClear,
      required this.function,
      this.itemAsString,
      this.flex = 1,
      this.hideOnLoading = false,
      this.controller,
      this.enabled = true,
      this.hint,
      this.validator,
      this.padding,
      this.border,
      this.itemBuilder,
      this.direction = AxisDirection.down,
      this.showAboveField = false,
      this.emptyWidget,
      this.readonly = true,
      this.prefixIcon,
      this.refreshOnTap = true,
      this.searchInApi = true,
      this.localData = false,
      this.contentPadding})
      : super(key: key);
  final Function(T) onChanged;
  final bool showSufix;
  final Widget? prefixIcon;
  final String? lable;
  final String? hint;
  final String? initialValue;
  final FutureOr<Iterable<T>> Function(String) function;
  final VoidCallback? onClear;
  final bool showClearIcon;
  final bool enabled;
  final bool readonly;
  final bool showLabel;
  final bool hideOnLoading;
  final bool showRequiredStar;
  final bool removeSelectedItem;
  final AxisDirection direction;
  final bool keepSuggestionAftertSelect;
  final TextEditingController? controller;
  final String Function(T)? itemAsString;
  final int flex;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? padding;
  final InputBorder? border;
  final bool showAboveField;
  final Widget? emptyWidget;
  final EdgeInsetsGeometry? contentPadding;
  final Widget Function(BuildContext, T)? itemBuilder;
  final bool searchInApi;
  final bool refreshOnTap;
  final bool localData;
  @override
  State<CustomAutoCompleteTextField<T>> createState() => _CutomAutoCompleteTextFeildState<T>();
}

class _CutomAutoCompleteTextFeildState<T> extends State<CustomAutoCompleteTextField<T>> {
  late TextEditingController controller;
  final LayerLink _layerLink = LayerLink();
  bool _hasOpenedOverlay = false;
  bool _isLoading = false;
  OverlayEntry? _overlayEntry;
  Timer? _debounce;
  String? selectedItem;
  List<T> suggestions = [];
  List<T> searchedSuggestions = [];

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController(text: widget.initialValue?.tr());

    super.initState();
  }

  @override
  void dispose() {
    _overlayEntry?.dispose();
    _debounce?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showLabel)
              Row(
                children: [
                  TextWidget(
                    widget.lable.toString(),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  if (widget.showRequiredStar)
                    TextWidget(
                      "*",
                      color: context.colorScheme.error,
                    )
                ],
              ),
            if (widget.showLabel)
              const SizedBox(
                height: 10,
              ),
            IgnorePointer(
                ignoring: !widget.enabled,
                child: WillPopScope(
                  onWillPop: () async {
                    if (_hasOpenedOverlay) {
                      closeOverlay();
                      return false;
                    } else {
                      return true;
                    }
                  },
                  child: CompositedTransformTarget(
                      link: _layerLink,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RawKeyboardListener(
                              focusNode: _focusNode,
                              onKey: (event) {
                                if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                                  if (hightlightIndex < searchedSuggestions.length - 1) {
                                    hightlightIndex++;
                                    rebuildOverlay();
                                  }
                                } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                                  if (hightlightIndex > 0) {
                                    hightlightIndex--;
                                    rebuildOverlay();
                                  }
                                } else if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                                  if (widget.keepSuggestionAftertSelect == false) {
                                    selectedItem = widget.itemAsString?.call(searchedSuggestions[hightlightIndex]) ??
                                        searchedSuggestions[hightlightIndex].toString();
                                    closeOverlay();
                                  }
                                  widget.onChanged(searchedSuggestions[hightlightIndex]);
                                }
                              },
                              child: TextFormField(
                                  key: _key,
                                  readOnly: widget.readonly,
                                  decoration: InputDecoration(
                                    hintText: widget.hint,
                                    filled: widget.enabled == true ? false : true,
                                    fillColor: Colors.grey.withOpacity(0.4),
                                    labelText: widget.showLabel ? null : widget.lable,
                                    prefixIcon: widget.prefixIcon,
                                    // border: const OutlineInputBorder(
                                    //   borderRadius: BorderRadius.all(
                                    //       Radius.circular(18.0)),
                                    // ),
                                    // enabledBorder: widget.border ??
                                    //     const OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //         Radius.circular(18.0),
                                    //       ),
                                    //       borderSide: BorderSide(
                                    //         color: Colors.grey,
                                    //         width: 1.0,
                                    //         style: BorderStyle.solid,
                                    //       ),
                                    //     ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8,
                                        ),
                                        borderSide: BorderSide(color: Color(0xff8CAAC5))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8,
                                        ),
                                        borderSide: BorderSide(color: Color(0xff8CAAC5))),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8,
                                        ),
                                        borderSide: BorderSide(color: Color(0xff8CAAC5))),
                                    suffix: (widget.showClearIcon)
                                        ? Padding(
                                            padding: const EdgeInsets.only(bottom: 12),
                                            child: IconButton(
                                              onPressed: () {
                                                widget.onClear?.call();
                                                controller.text = "";
                                                selectedItem = null;
                                              },
                                              icon: const Icon(Icons.clear),
                                            ),
                                          )
                                        : null,
                                    suffixIcon: widget.showSufix
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.keyboard_arrow_down,
                                              )
                                            ],
                                          )
                                        : null,
                                  ),
                                  controller: controller,
                                  onChanged: (s) {
                                    if (!_hasOpenedOverlay) openOverlay();
                                    if (widget.searchInApi) {
                                      updateSuggestions(s);
                                    } else {
                                      searchedSuggestions = suggestions
                                          .where((element) =>
                                              widget.itemAsString
                                                  ?.call(element)
                                                  .toLowerCase()
                                                  .contains(s.toLowerCase()) ??
                                              true)
                                          .toList();
                                      rebuildOverlay();
                                    }
                                  },
                                  onTap: () {
                                    openOverlay();
                                    updateSuggestions(controller.text, refresh: widget.refreshOnTap);
                                  },
                                  // onEditingComplete: () => closeOverlay(),
                                  validator: widget.validator != null ? (value) => widget.validator!(value) : null //
                                  ),
                            )
                          ])),
                )),
          ],
        ));
  }

  int hightlightIndex = 0;
  void closeOverlay() {
    if (_hasOpenedOverlay) {
      if (selectedItem != null) {
        controller.text = selectedItem ?? "";
      } else {
        controller.text = "";
      }
      _overlayEntry!.remove();
      setState(() {
        _hasOpenedOverlay = false;
      });
    }
  }

  final FocusNode _focusNode = FocusNode();
//global key
  final GlobalKey _key = GlobalKey();
  void openOverlay() {
    controller.text = '';
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    _overlayEntry = OverlayEntry(builder: (context) => suggestionList(offset, size, context));
    if (_hasOpenedOverlay == false) {
      print("object");
      Overlay.of(context).insert(_overlayEntry!);
      setState(() => _hasOpenedOverlay = true);
    }
  }

  Widget suggestionList(Offset offset, Size size, BuildContext context) {
    final h = context.size!.height * 0.5;
    return Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, widget.showAboveField ? -h : size.height + 5),
          child: TapRegion(
            onTapOutside: (event) {
              closeOverlay();
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(10.0)),
              margin: EdgeInsets.zero,
              color: context.scaffoldBackgroundColor.withOpacity(0.9),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: context.size!.height * 0.3),
                child: _isLoading
                    ? const Center(
                        child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ))
                    : searchedSuggestions.isEmpty
                        ? widget.emptyWidget ??
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("No Items"),
                            )
                        : Scrollbar(
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: searchedSuggestions.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) => InkWell(
                                      onTap: () {
                                        if (widget.keepSuggestionAftertSelect == false) {
                                          selectedItem = widget.itemAsString?.call(searchedSuggestions[index]) ??
                                              searchedSuggestions[index].toString();

                                          hightlightIndex = index;
                                          closeOverlay();
                                        }
                                        widget.onChanged(searchedSuggestions[index]);
                                      },
                                      child: widget.itemBuilder?.call(context, searchedSuggestions[index]) ??
                                          ListTile(
                                              tileColor: hightlightIndex == index ? Colors.grey.withOpacity(0.2) : null,
                                              shape: const UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.grey)),
                                              title: SelectionContainer.disabled(
                                                child: Text(widget.itemAsString?.call(searchedSuggestions[index]) ??
                                                    searchedSuggestions[index].toString()),
                                              )),
                                    )),
                          ),
              ),
            ),
          ),
        ));
  }

  void rebuildOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  Future<void> updateSuggestions(String input, {bool refresh = false}) async {
    if (widget.searchInApi == false && suggestions.isNotEmpty && !refresh) {
      searchedSuggestions = suggestions
          .where((element) => widget.itemAsString?.call(element).toLowerCase().contains(input.toLowerCase()) ?? true)
          .toList();
      rebuildOverlay();
      return;
    }
    setState(() => _isLoading = true);

    if (_debounce != null && _debounce!.isActive) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: widget.localData ? 0 : 600), () async {
      suggestions = (await widget.function.call(input)).toList();
      searchedSuggestions = suggestions
          .where((element) => widget.itemAsString?.call(element).toLowerCase().contains(input.toLowerCase()) ?? true)
          .toList();

      setState(() {
        _isLoading = false;
      });
      rebuildOverlay();
    });
  }
}
