var lib = lib || {};

lib.release = (function ($, m) {
    function parse_query_string(query) {
        var vars = query.split("&");
        var query_string = {};
        for (var i = 0; i < vars.length; i++) {
            var pair = vars[i].split("=");
            // If first entry with this name
            if (typeof query_string[pair[0]] === "undefined") {
                query_string[pair[0]] = decode_and_sanitize(pair[1]);
                // If second entry with this name
            } else if (typeof query_string[pair[0]] === "string") {
                query_string[pair[0]] = [query_string[pair[0]], decode_and_sanitize(pair[1])];
                // If third or later entry with this name
            } else {
                query_string[pair[0]].push(decode_and_sanitize(pair[1]));
            }
        }
        return query_string;
    }

    function parse_asset(asset) {
        console.log(asset);
        window.location.href = asset.browser_download_url;

        $("#content").html(
            "If you are not redirected automatically, " +
            "follow the <a href='" + asset.browser_download_url +
            "'>link</a></a>");
        
        // Allow wget and curl to discover the URL   
        // $("#content").html(asset.browser_download_url);
    }

    function get_latest_release(repo, os, version, arch, type) {
        $.getJSON(repo).done(function (json) {
            var assets = json.assets;
            // rakudo-CentOS7.4.1708-20171000-01.x86_64.rpm
            // rakudo-Ubuntu17.04_20171000-01_i386.deb
            var regex_pkgs = new RegExp(".*" + os + version + ".*" + arch + ".*", "i");
            var regex_sha  = new RegExp(".*\.sha1$");

            for (var i = 0, len = assets.length; i < len; i++) {
                if (regex_pkgs.test(assets[i].name)) {
                    if (type == 'sha' && regex_sha.test(assets[i].name)) {
                        parse_asset(assets[i]);
                        return
                    }
                    else if (type == 'pkg' && !regex_sha.test(assets[i].name)){
                        parse_asset(assets[i]);
                        return;
                    }
                }
            }

            $("#content").html("Couldn't find release based on: <br /><br />" +
                "<strong>os:</strong> "      + os      + "<br />" +
                "<strong>version:</strong> " + version + "<br />" +
                "<strong>arch:</strong> "    + arch    + "<br />");
        });
    }

    function decode_and_sanitize(input) {
        return m.escape(decodeURIComponent(input));
    }

    function init(type) {
        var query     = window.location.search.substring(1);
        var parsed_qs = parse_query_string(query);

        var defined_os      = (parsed_qs.os);
        var defined_version = (parsed_qs.version);
        var defined_arch    = (parsed_qs.arch);

        //$("#debug_GET_parameters").append(defined_os      + "<br/>");
        //$("#debug_GET_parameters").append(defined_version + "<br/>");
        //$("#debug_GET_parameters").append(defined_arch    + "<br/>");
        get_latest_release("https://api.github.com/repos/nxadm/rakudo-pkg/releases/latest", defined_os, defined_version, defined_arch, type);
    }

    return {
        get_release : function (type) {
            if (m == undefined || $ == undefined) {
                console.log("Woops, don't forget the dependent libs brah.");
                return;
            }
            init(type);
        }
    }

})(jQuery, Mustache);
