function buildResults = build()

appFile = "../EEGClassifier.m";
buildResults = compiler.build.standaloneApplication(appFile);

end