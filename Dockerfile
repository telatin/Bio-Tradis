# This container will install Bio-Tradis from master
#
FROM debian:testing

# Install the dependancies
RUN apt-get update -qq && apt-get install -y sudo make wget unzip zlib1g-dev cpanminus gcc bzip2 libncurses5-dev libncursesw5-dev libssl-dev r-base git
RUN cpanm IPC::System::Simple DateTime::Locale DateTime Dist::Zilla
RUN dzil authordeps --missing | cpanm && dzil listdeps --missing | cpanm
RUN sudo Rscript -e "source('http://bioconductor.org/biocLite.R')" -e "biocLite(c('edgeR','getopt', 'MASS'))"
#RUN git clone https://github.com/sanger-pathogens/Bio-Tradis.git
RUN apt-get -y install bwa smalt tabix samtools
ADD . Bio-Tradis
#RUN cd Bio-Tradis && ./install_dependencies.sh
#ENV PATH /Bio-Tradis/bin:/Bio-Tradis/build/smalt-0.7.6-bin:/Bio-Tradis/build/bwa-0.7.17:/Bio-Tradis/build/tabix-master:/Bio-Tradis/build/samtools-1.3:$PATH
ENV PATH /Bio-Tradis/bin:$PATH
RUN export PATH
ENV PERL5LIB=/Bio-Tradis/lib:$PERL5LIB
RUN export PERL5LIB
WORKDIR /work
