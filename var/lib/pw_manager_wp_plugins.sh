#!/bin/bash


wp_package_plugins() {
    echo "Packaging plugins ..."
    
    cd $PW_SERVICES_DIR"/wp/plugins"

    # for each folder in the plugins directory, create a zip file
    for plugin in $(ls -d */); do
        plugin_name=$(echo $plugin | sed 's/\///')
        echo "Packaging $plugin_name ..."
        zip -q -r $plugin_name".zip" $plugin_name
    done

    # Move the zip files to the plugins directory
    mkdir -p $PW_TMP_DIR"/wp/plugins" 2>/dev/null
    mv *.zip $PW_TMP_DIR"/wp/plugins"

    sudo mkdir -p $PW_SHARED_DIR"/wp/plugins" #2>/dev/null
    sudo cp -r $PW_TMP_DIR"/wp/" $PW_SHARED_DIR

    echo "Plugins packaged successfully. Files are located in $PW_TMP_DIR/wp/plugins"
}