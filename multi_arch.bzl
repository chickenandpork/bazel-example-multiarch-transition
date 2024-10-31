def _multi_arch_transition_impl(settings, attr):
    return [
        {"//command_line_option:platforms": str(platform)}
        for platform in attr.platforms
    ]

multi_arch_transition = transition(
    implementation = _multi_arch_transition_impl,
    inputs = [],
    outputs = ["//command_line_option:platforms"],
)

def _multi_arch_impl(ctx):
    return DefaultInfo(files = depset(ctx.files.image))

multi_arch = rule(
    implementation = _multi_arch_impl,
    attrs = {
        "image": attr.label(cfg=multi_arch_transition),
        "platforms": attr.label_list(),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        )
    }
)
