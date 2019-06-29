function BuybidGui () {}

BuybidGui.templates = {}

BuybidGui.register_template = function(template, render) {
    BuybidGui.templates[template] = render;
}

BuybidGui.render = function(container, template, data) {
    if (!BuybidGui.templates[template]) {
        return '';
    }
    $(container).append(
        BuybidGui.templates[template].render(data));
}
