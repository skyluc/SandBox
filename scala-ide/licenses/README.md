# Extract licenses information

## from Eclipse plugin's about.html file

`extractLicenses.sh` go through the `plugin` folder of an Eclipse install, and try to group plugins which share the same `about.html`.

## from maven generated license files

The [license-maven-plugin](http://mojo.codehaus.org/license-maven-plugin/examples/example-download-licenses.html) extract the license information of the dependencies (transitively), and put them in `target/generated-resources/licenses.xml` file.

The `Licenses.scala` app parse these files, and produce a prettier output. The list of files to check is hardcoded in the object. It was created using `find . -name 'licenses.xml`.

