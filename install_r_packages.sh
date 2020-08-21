echo 'install.packages("devtools", repos="https://cloud.r-project.org/", upgrade_dependencies=FALSE, INSTALL_opts = c("--no-lock") )' | R --no-save
echo 'require(devtools); install_version("kernlab", version="0.9-24", repos="https://cloud.r-project.org/", upgrade_dependencies=FALSE, INSTALL_opts = c("--no-lock"))' | R --no-save && \
echo 'require(devtools); install_version("ROCR", version="1.0-7", repos="https://cloud.r-project.org/", upgrade_dependencies=FALSE, INSTALL_opt=c("--no-lock"))' | R --no-save && \
echo 'require(devtools); install_version("class", version="7.3-14", repos="https://cloud.r-project.org/", upgrade_dependencies=FALSE, INSTALL_opt=c("--no-lock"))' | R --no-save && \
echo 'require(devtools); install_version("mvtnorm", version="1.0-8", repos="https://cloud.r-project.org/", upgrade_dependencies=FALSE, INSTALL_opt=c("--no-lock"))' | R --no-save && \
echo 'require(devtools); install_version("multcomp", version="1.4-8", repos="https://cloud.r-project.org/", upgrade_dependencies=FALSE, INSTALL_opt=c("--no-lock"))' | R --no-save && \
echo 'require(devtools); install_version("coin", version="1.2-2", repos="https://cloud.r-project.org/", upgrade_dependencies=FALSE, INSTALL_opt=c("--no-lock"))' | R --no-save && \
echo 'require(devtools); install_version("strucchange", version="1.5-1", repos="https://cloud.r-project.org/", upgrade_dependencies=FALSE, INSTALL_opt=c("--no-lock"))' | R --no-save && \
echo 'require(devtools); install_version("libcoin", version="1.0-5", repos="https://cloud.r-project.org/", upgrade_dependencies=FALSE, INSTALL_opt=c("--no-lock"))' | R --no-save && \
echo 'require(devtools); install_version("matrixStats", repos="https://cloud.r-project.org/", upgrade_dependencies=FALSE, INSTALL_opt=c("--no-lock"))' | R --no-save && \
echo 'require(devtools); install_version("party", version="1.0-25", repos="https://cloud.r-project.org/", upgrade_dependencies=FALSE, INSTALL_opt=c("--no-lock"), dependencies=FALSE)' | R --no-save && \
echo 'require(devtools); install_version("e1071", version="1.6-7", repos="https://cloud.r-project.org/", upgrade_dependencies=FALSE, INSTALL_opt=c("--no-lock"))' | R --no-save && \
echo 'require(devtools); install_version("randomForest", version="4.6-12", repos="https://cloud.r-project.org/", upgrade_dependencies=FALSE, INSTALL_opt=c("--no-lock"))' | R --no-save

