module namespace intl="http://exist-db.org/xquery/i18n/templates";

(:~
 : i18n template functions. Integrates the i18n library module. Called from the templating framework.
 :)
import module namespace i18n="http://exist-db.org/xquery/i18n" at "xmldb:exist:///db/demo/modules/i18n.xql";
import module namespace templates="http://exist-db.org/xquery/templates" at "xmldb:exist:///db/demo/modules/templates.xql";
import module namespace config="http://exist-db.org/xquery/apps/config" at "config.xqm";

(:~
 : Template function: calls i18n:process on the child nodes of $node.
 : Template parameters:
 :      lang=de Language selection
 :      catalogues=relative path    Path to the i18n catalogue XML files inside database
 :)
declare function intl:translate($node as node(), $params as element(parameters)?, $model as item()*) {
    let $selectedLang := $params/param[@name = "lang"]/@value
    let $catalogues := $params/param[@name = "catalogues"]/@value
    let $cpath :=
        (: if path to catalogues is relative, resolve it relative to the app root :)
        if (starts-with($catalogues, "/")) then
            $catalogues
        else
            concat($config:app-root, "/", $catalogues)
    let $translated :=
        i18n:process($node/*, $selectedLang, $cpath, ())
    return
        element { node-name($node) } {
            $node/@*,
            templates:process($translated, $model)
        }
};