// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-28T11:14:07.721Z

part of app.view;

// **************************************************************************
// Generator: UixGenerator
// Target: class AppView
// **************************************************************************

AppView createAppView([AppState data, List<VNode> children, Component parent]) {
  return new AppView()
    ..parent = parent
    ..data = data
    ..children = children;
}
VNode vAppView({AppState data, Object key, String type,
    Map<String, String> attrs, Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createAppView,
    flags: VNode.componentFlag,
    key: key,
    data: data,
    type: type,
    attrs: attrs,
    style: style,
    classes: classes,
    children: children);
