rm -rf $HOME/plan
    mkdir $HOME/plan
    cp $file $HOME/plan
    cd $HOME/plan
    mv *.tar plan.tar
    tar -xvf plan.tar