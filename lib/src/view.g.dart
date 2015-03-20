// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-20T04:31:40.227Z

part of app.view;

// **************************************************************************
// Generator: UixGenerator
// Target: class AppView
// **************************************************************************

AppView createAppView([AppState data]) {
  final r = new AppView()..data = data;
  r.init();
  return r;
}
VNode vAppView({AppState data, Object key, String type,
    Map<String, String> attrs, Map<String, String> style, List<String> classes,
    List<VNode> children}) => new VNode.component(createAppView,
    flags: VNode.componentFlag | VNode.dirtyCheckFlag,
    key: key,
    data: data,
    type: type,
    attrs: attrs,
    style: style,
    classes: classes,
    children: children);
