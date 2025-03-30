        
        rm -rf /data/local/tmp/*.apk
        cp $app /data/local/tmp/
        chmod 777 /data/local/tmp/*.apk
        pm install --user 999 /data/local/tmp/*.apk
        rm -rf /data/local/tmp/app/*.apk